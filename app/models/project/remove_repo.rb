class Project
  class RemoveRepo
    @queue = :project
    
    def self.perform(project_id)
      Strano::Repo.remove Project.unscoped.find(project_id).url
    end
  end
end