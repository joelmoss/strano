class SessionsController < ApplicationController
  
  def new
    redirect_to '/auth/github'
  end
  
  # Handles the Omniauth callback after a successful Github sign in. We first
  # find or create the user by the email. If the user is not found, then we
  # redirect to sign page with the error message as a flash. If the user was
  # found, then we sign in and redirect.
  def create
    data = request.env["omniauth.auth"][:extra][:raw_info]
    attributes = { :github_data => data, :github_access_token => request.env["omniauth.auth"][:credentials][:token] }
    user = User.find_or_create_by_email(data[:email], attributes)
    
    session[:user_id] = user.id
    redirect_to root_url, :notice => 'Successfully signed in via Github!'
  end
  
  def destroy
    reset_session
    redirect_to root_url, :notice => 'You have been signed out. Come back soon now!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
  
end