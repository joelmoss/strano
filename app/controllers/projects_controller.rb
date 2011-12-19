class ProjectsController < InheritedResources::Base
  actions :all, :except => :index
  
  
  def new
    @repos = current_user.github.repos.repos
    new!
  end
  
  def destory
    destroy { root_url(:anchor => "projects") }
  end
  
  
  protected
  
    def begin_of_association_chain
      current_user
    end
  
end