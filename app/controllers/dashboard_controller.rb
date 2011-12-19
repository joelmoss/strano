class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @repos = current_user.github.repos.repos
    # @repos.delete_if do |r|
    #   branch = r.master_branch || 'master'      
    #   github.git_data.tree r.owner.login, r.name, branch do |o|
    #     return true if o.path == 'Capfile'
    #   end
    # end
    @projects = Project.all
  end
end