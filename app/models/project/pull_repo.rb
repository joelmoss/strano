class Project
  class PullRepo
    include Sidekiq::Worker

    def self.perform(project_id)
      new.perform(project_id)
    end

    def perform(project_id)
      begin
        project = Project.find(project_id)
      rescue ActiveRecord::RecordNotFound
        return
      end

      project.update_column :pull_in_progress, true

      Strano::Repo.pull project.url

      Project.update_all({:updated_at => Time.now,
                          :pulled_at => Time.now,
                          :pull_in_progress => false},
                          :id => project_id)
    end
  end
end