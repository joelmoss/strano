require 'spec_helper'

describe "Authentication" do

  context "on successful sign in" do
    use_vcr_cassette 'Github_Key/_create', :erb => true

    before(:each) do
      OmniAuth.config.mock_auth[:github] = { :credentials => { :token => "65r6w5er1w6er5w65ef1" },
                                             :extra => {
                                               :raw_info => {
                                                 :login => "testuser" } } }
    end

    it "should create a new User record" do
      get "/auth/github"
      follow_redirect!
      User.should have(1).record
    end

    context "when user record already exists" do
      before(:each) { User.disable_ssh_github_upload = true }

      it "should use the existing record" do
        user = FactoryGirl.create(:user)
        OmniAuth.config.mock_auth[:github][:extra][:raw_info][:login] = user.username

        get "/auth/github"
        follow_redirect!
        User.should have(1).record
      end
    end
  end

  context "on unsuccessful sign in" do
    it "does something" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      get "/auth/github"
      follow_redirect!
      response.should redirect_to('/auth/failure?message=invalid_credentials')
    end
  end

end
