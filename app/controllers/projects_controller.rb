class ProjectsController < InheritedResources::Base
  
  
  protected
  
    def begin_of_association_chain
      current_user
    end
  
end