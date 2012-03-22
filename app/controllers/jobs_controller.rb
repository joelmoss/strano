class JobsController < InheritedResources::Base

  belongs_to :project
  actions :all, :except => :index
  respond_to :json, :only => :show

  before_filter :authenticate_user!
  before_filter :ensure_unlocked_project, :only => [:new, :create, :delete]

  rescue_from Strano::ProjectCapError do |e|
    redirect_to parent, :alert => e.message and return
  end


  def new
    @job = parent.jobs.build params[:job]
    # TODO write in the README that all the projects that use multistage need one
    # default_stage configuration
    @job.stage = parent.cap.default_stage if parent.cap.namespaces.keys.include?(:multistage)

    new!
  end

  def create
    create! :notice => "Your new job is being processed..."
  end


  private

    def begin_of_association_chain
      params[:job] ||= {}
      params[:job][:task] ||= params[:task]
      params[:job][:user] = current_user

      super
    end

    def ensure_unlocked_project
      if parent.job_in_progress?
        redirect_to parent, :alert => "Unable to run tasks while a job is in progress." and return
      end
    end

end
