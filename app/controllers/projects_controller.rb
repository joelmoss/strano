class ProjectsController < InheritedResources::Base
  before_filter :authenticate_user!  
  before_filter :ensure_accessibility_by_current_user, :except => [:index, :new, :create]
  respond_to :json, :only => :show
  
  
  def new
    @repos = current_user.github.repos.repos
    new!
  end
  
  def destory
    destroy { root_url(:anchor => "projects") }
  end
  
  
  private
  
    def ensure_accessibility_by_current_user
      unless resource.accessible_by? current_user
        redirect_to collection_path, :alert => "You do not have access to this project '#{resource}'."
      end
    end
   
end