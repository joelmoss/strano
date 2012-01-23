class Job
  class CapExecute
    @queue = :job
    
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
end