class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_strano_user_token
  
  
  private
  
    # Tells Strano models without a user association who the current user is.
    def set_strano_user_token
      ::Github.strano_user_token = current_user.github_access_token rescue nil
    end
  
end
