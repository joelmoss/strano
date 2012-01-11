class DashboardController < ApplicationController

  def index
    redirect_to projects_url if signed_in?
  end

end