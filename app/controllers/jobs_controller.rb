class JobsController < InheritedResources::Base
  before_filter :authenticate_user!
  belongs_to :project
  actions :all, :except => :index
  respond_to :json, :only => :show


  def new
    @job = parent.jobs.build params[:job]
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

end