class Job < ActiveRecord::Base
  
  belongs_to :project
  belongs_to :user
  after_create :execute_task
  
  default_scope order('created_at DESC')
  
  

  def run_task
    capture_stdout { project.cap %W( #{task} ) }.string
  end
  
  def complete?
    !results.blank?
  end
  
  
  private
  
    def execute_task
      CAP_EXECUTE_QUEUE.push({:job_id => id}) do |result|
        update_attributes :results => result, :completed_at => Time.now
      end
    end
    
end
