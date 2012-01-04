class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @projects = Project.all
  end
end