require 'spec_helper'

describe Project do
  let(:url) { 'git@github.com:joelmoss/strano.git' }
  let(:user) { FactoryGirl.create(:user) }
  let(:cloned_project) { FactoryGirl.build_stubbed(:project) }

  before(:each) do
    Github.strano_user_token = user.github_access_token
  end

  context "#create" do
    let(:project) { Project.create :url => url }

    it "should set the data after save", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      project.data.should_not be_empty
    end

    describe "#repo", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      it { project.repo.should be_a(Strano::Repo) }
    end

    describe "#github", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      it { project.github.should be_a(Github::Repo) }
    end
  end

  describe "#creat_hook" do
    let(:project) { Project.new :url => url }

    context "when Strano.base_url is nil", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      it "shouldn't create a hook" do
        project.github.should_not_receive(:hook)
      end
    end

    context "when Strano.base_url is not nil", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      before(:each) do
        Strano.stub(:base_url).and_return('http://example.com/listener')
      end

      it "should create a hook" do
        project.github.should_receive(:hook)
      end
    end

    after(:each) do
      project.save
    end
  end
end
