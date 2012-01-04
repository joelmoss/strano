require 'kernel'

class Job < ActiveRecord::Base
  
  class CapExecute
    def self.perform(job_id)
      job = Job.find(job_id)
      
      result = begin
        job.run_task
      rescue Exception => e
        e.message
      end
      
      job.update_attributes :results => result, :completed_at => Time.now
    end
  end
  
  belongs_to :project
  belongs_to :user
  after_create :execute_task
  
  default_scope order('created_at DESC')
  default_scope where(:deleted_at => nil)


  def self.deleted
    self.unscoped.where 'deleted_at IS NOT NULL'
  end
  

  def run_task
    capture_stdout { project.cap [stage, task] }.string
  end
  
  def complete?
    !results.blank?
  end
  
  
  private
  
    def execute_task
      Qu.enqueue Job::CapExecute, id
    end
    
end
