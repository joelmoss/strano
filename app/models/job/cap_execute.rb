class Job
  class CapExecute
    include Ansible
    
    @queue = :job
    
    def self.perform(job_id)
      job = Job.find(job_id)
      
      result = begin
        success = true
        job.run_task
      rescue
        success = false
        $!.message
      end
      
      job.update_attributes :results => new.ansi_escaped(result),
                            :completed_at => Time.now,
                            :success => success
    end
  end
end