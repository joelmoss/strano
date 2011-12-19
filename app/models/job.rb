class Job < ActiveRecord::Base
  
  belongs_to :project
  after_create :execute_task
  
  

  def run_task
    capture_stdout { project.cap %W( #{task} ) }.string
  end
  
  
  private
  
    def execute_task
      CAP_EXECUTE_QUEUE.push({:job_id => id}) do |result|
        update_attribute :results, result
      end
    end
    
end
