class Job
  class CapExecute
    include Sidekiq::Worker, Ansible

    def perform(job_id)
      job = Job.find(job_id)

      # Make sure the local repo is up to date.
      # Project::PullRepo.perform(job.project.id) unless job.project.pull_in_progress?

      job.run_task

      job.update_attributes :completed_at => Time.now, :success => true
    end

  end
end