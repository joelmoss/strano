require 'kernel'
class Job < ActiveRecord::Base

  belongs_to :project
  belongs_to :user
  after_create :execute_task

  default_scope order('created_at DESC')
  default_scope where(:deleted_at => nil)


  def self.deleted
    self.unscoped.where 'deleted_at IS NOT NULL'
  end


  def run_task
    success = true

    FileUtils.chdir project.repo.path do
      out = capture_stdout do
        success = Strano::CLI.parse(Strano::Logger.new(self), full_command).execute!
      end

      puts "\n  > #{out.string}" unless out.string.blank?
    end

    !!success
  end

  def complete?
    !completed_at.nil?
  end

  def command
    "#{stage} #{task}"
  end

  def puts(msg)
    update_attribute :results, (results || '') + msg unless msg.blank?
  end


  private

    def full_command
      %W(-f #{Rails.root.join('Capfile.repos')} -f Capfile -Xx#{verbosity}) + command.split(' ')
    end

    def execute_task
      CapExecute.perform_async id
    end

end
