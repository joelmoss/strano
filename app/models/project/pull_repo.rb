class Project
  class PullRepo
    @queue = :project
    
    def self.perform(project_id)
      project = Project.find(project_id)
      project.update_column :pull_in_progress, true
      
      Strano::Repo.pull project.url
      
      Project.update_all({:updated_at => Time.now,
                          :pulled_at => Time.now,
                          :pull_in_progress => false},
                          :id => project_id)
    end
  end
end