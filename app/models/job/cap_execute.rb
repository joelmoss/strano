class Job
  module ReportFailure
    def on_failure_retry(e, job_id)
      job = Job.find(job_id)
    
      job.update_attributes :results => e.message,
                            :completed_at => Time.now,
                            :success => false
    end
  end

  class CapExecute
    include Ansible
    extend ReportFailure
    
    @queue = :job
    
    def self.perform(job_id)
      job = Job.find(job_id)
      
      # Make sure the local repo is up to date.
      Project::PullRepo.perform(job.project.id) unless job.project.pull_in_progress?
      
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