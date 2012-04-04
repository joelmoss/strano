class Job
  class CapExecute
    include Sidekiq::Worker

    def perform(job_id)
      begin
        job = Job.find(job_id)
      rescue ActiveRecord::RecordNotFound
        return
      end

      # Make sure the local repo is up to date.
      Project::PullRepo.perform(job.project.id) unless job.project.pull_in_progress?

      job.update_attributes :completed_at => Time.now, :success => job.run_task
    end

  end
end