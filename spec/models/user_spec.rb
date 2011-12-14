require 'spec_helper'

describe User do

  describe "upload Strano SSH key to users Github account after creation" do
    it "should upload SSH key to Github" do
      Github::Users.any_instance.should_receive(:create_key).with(:title => "Strano", :key => "stranoshakey")
      user = FactoryGirl.create(:user)
      user.ssh_key_uploaded_to_github?.should == true
    end
  end
  
  describe "#authorized_for_github?" do
    before(:each) { User.disable_ssh_github_upload = true }
    
    it { FactoryGirl.build(:user, :github_access_token => nil).authorized_for_github?.should == false }
    it { FactoryGirl.create(:user).authorized_for_github?.should == true }
  end

  describe "#github" do
    before(:each) { User.disable_ssh_github_upload = true }
    
    it { FactoryGirl.build(:user, :github_access_token => nil).github.should be_nil }
    it { FactoryGirl.create(:user).github.should be_a(Github::Client) }
    it { FactoryGirl.create(:user).github.oauth_token.should == 'somerandomstring' }
  end

end
