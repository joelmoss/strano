class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # Handles the Omniauth callback after a successful Github sign in. We first
  # find or create the user by the email. If the user is not found, then we
  # redirect to sign page with the error message as a flash. If the user was
  # found, then we sign in and redirect.
  def github
    data = request.env["omniauth.auth"][:extra][:raw_info]
    attributes = { :github_data => data,
                   :github_access_token => request.env["omniauth.auth"][:credentials][:token] }
    user = User.find_or_create_by_email(data[:email], attributes)
    
    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Github"
      sign_in_and_redirect user, :event => :authentication
    else
      redirect_to new_user_session_url
    end
  end
  
  
  protected
  
    def after_omniauth_failure_path_for(scope)
      new_user_session_url
    end
  
end