class ProjectsController < InheritedResources::Base
  actions :all, :except => :index
  
  
  def destory
    destroy { root_url(:anchor => "projects") }
  end
  
  
  protected
  
    def begin_of_association_chain
      current_user
    end
  
end