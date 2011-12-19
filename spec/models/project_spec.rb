require 'spec_helper'

describe Project do

  before(:each) { User.disable_ssh_github_upload = true }

  let(:url) { 'git@github.com:joelmoss/strano.git' }
  let(:user) { FactoryGirl.create(:user) }
  let(:cloned_project) { FactoryGirl.build_stubbed(:project) }
  let(:project) do
    Strano::Repo.should_receive(:clone).with(url)
    Project.create(:url => url, :user_id => user.id)
  end
  
  use_vcr_cassette
  
  it "should set the github data after save" do
    project.github_data.should_not be_empty
  end
  
  describe "#repo" do
    it { project.repo.should be_a(Strano::Repo) }
  end
  
  describe "#github" do
    it { project.github.should be_a(Github::Repos) }
  end
  
end
