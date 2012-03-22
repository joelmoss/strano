class Project
  class RemoveRepo
    include Sidekiq::Worker

    def perform(project_id)
      Strano::Repo.remove Project.unscoped.find(project_id).url
    end
  end
end