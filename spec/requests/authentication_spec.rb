require 'spec_helper'

describe "Authentication" do

  context "on successful sign in" do
    before(:each) do
      OmniAuth.config.mock_auth[:github] = { :credentials => { :token => "65r6w5er1w6er5w65ef1" },
                                             :extra => {
                                               :raw_info => {
                                                 :email => "test@test.com" } } }
    end
    
    it "should create a new User record" do
      get_via_redirect "/users/auth/github"
      User.should have(1).record
    end

    context "when user record already exists" do
      it "should use the existing record" do
        user = FactoryGirl.create(:user)
        OmniAuth.config.mock_auth[:github][:extra][:raw_info][:email] = user.email
    
        get_via_redirect "/users/auth/github"
        User.should have(1).record
      end
    end
  end

  context "on unsuccessful sign in" do
    it "does something" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
  
      get "/users/auth/github"
      follow_redirect!
      response.should redirect_to('/sign_in')
    end
  end

end
