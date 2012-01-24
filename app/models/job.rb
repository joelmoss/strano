require 'kernel'
class Job < ActiveRecord::Base
  include Ansible

  belongs_to :project
  belongs_to :user
  after_create :execute_task

  default_scope order('created_at DESC')
  default_scope where(:deleted_at => nil)


  def self.deleted
    self.unscoped.where 'deleted_at IS NOT NULL'
  end


  def run_task
    status, stdout_output, stderr_output = nil, "", ""

    FileUtils.chdir project.repo.path do
      status = Open4::popen4 full_command do |pid, stdin, stdout, stderr|
        stdin.close

        stdout_output += stdout.read.strip
        stderr_output += stderr.read.strip
      end
    end

    if status.exitstatus != 0
      stderr_output
    else
      stdout_output
    end
  end

  def complete?
    !completed_at.nil?
  end
  
  def command
    "#{stage} #{task}"
  end

  def formatted_results
    ansi_escaped results
  end


  private

    def full_command
      "bundle exec cap -f #{Rails.root.join('Capfile.repos')} -f Capfile -Xx -l STDOUT #{command}"
    end

    def execute_task
      Resque.enqueue CapExecute, id
    end

end
