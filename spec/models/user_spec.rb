require 'spec_helper'

describe User do

  describe "upload Strano SSH key to users Github account after creation" do
    use_vcr_cassette 'Github_Key/_create', :erb => true
    
    it "should upload SSH key to Github" do
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
    it { FactoryGirl.create(:user).github.should be_a(Github) }
  end

end
