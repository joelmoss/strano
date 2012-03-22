class ProjectsController < InheritedResources::Base

  before_filter :authenticate_user!
  before_filter :pull_repo, :only => [:show, :edit]
  before_filter :ensure_accessibility_by_current_user, :except => [:index, :new, :create]

  respond_to :json, :only => :show

  custom_actions :resource => :pull


  def show
    show! do
      @recent_tasks = resource.jobs.group(:task).order(:created_at).limit(5)
    end
  end

  def pull
    resource.pull!
    redirect_to resource, :notice => "Local repository is being updated..."
  end

  def destory
    destroy! { root_url(:anchor => "projects") }
  end


  private

    def ensure_accessibility_by_current_user
      unless resource.accessible_by? current_user
        redirect_to collection_path, :alert => "You do not have access to this project '#{resource}'."
      end
    end

    def pull_repo
      resource.pull
    end

end