class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @repos = Github::Repos.new(:oauth_token => current_user.github_access_token).repos
    @projects = Project.all
  end
end