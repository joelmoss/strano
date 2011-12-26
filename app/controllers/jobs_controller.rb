class JobsController < InheritedResources::Base
  before_filter :authenticate_user!
  belongs_to :project
  actions :all, :except => :index
  respond_to :json, :only => :show

  
  def create
    create! :notice => "Your new job is being processed..."
  end


  private

    def begin_of_association_chain
      params[:job] ||= {}
      params[:job][:task] ||= params[:task]
      params[:job][:user_id] ||= current_user

      super
    end

end