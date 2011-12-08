require 'spec_helper'

describe User do

  describe "upload Strano SSH key to users Github account after creation" do
    it "should upload SSH key to Github" do
      Github::Users.any_instance.should_receive(:create_key).with(:title => "Strano", :key => "stranoshakey")
      FactoryGirl.create(:user)
    end
  end

  describe "#github" do
    before(:each) do
      User.disable_ssh_github_upload = true
    end
    
    it { FactoryGirl.build(:user, :github_access_token => nil).github.should be_nil }
    it { FactoryGirl.create(:user).github.should be_a(Github::Users) }
    it { FactoryGirl.create(:user).github.oauth_token.should == 'somerandomstring' }
  end

end
