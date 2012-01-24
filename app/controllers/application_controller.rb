class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_strano_user_token
  
  helper_method :current_user
  helper_method :signed_in?
  

  private
  
    def current_user
      return nil unless session[:user_id]
      
      begin
        @current_user ||= User.find(session[:user_id])
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

    def signed_in?
      !current_user.nil?
    end

    def authenticate_user!
      unless signed_in?
        redirect_to sign_in_url, :alert => 'You need to sign in for access to this page.'
      end
    end
  
    # Tells Strano models without a user association who the current user is.
    def set_strano_user_token
      Github.strano_user_token = current_user.github_access_token rescue nil
    end
  
end
