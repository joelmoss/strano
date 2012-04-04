class Project
  class RemoveRepo
    include Sidekiq::Worker

    def perform(project_id)
      begin
        Strano::Repo.remove Project.unscoped.find(project_id).url
      rescue ActiveRecord::RecordNotFound
        return
      end
    end
  end
end