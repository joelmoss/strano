require 'spec_helper'

describe Project do

  let(:url) { 'git@github.com:joelmoss/strano.git' }
  let(:user) { FactoryGirl.create(:user) }
  let(:cloned_project) { FactoryGirl.build_stubbed(:project) }

  context "after #create" do
    before(:each) do
      Github.strano_user_token = user.github_access_token
      @project = Project.create :url => url
    end

    it "should set the data after save", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      @project.data.should_not be_empty
    end

    describe "#repo", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      it { @project.repo.should be_a(Strano::Repo) }
    end

    describe "#github", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      it { @project.github.should be_a(Github::Repo) }
    end
  end

  describe "Strano.base_url" do
    before(:each) do
      Github.strano_user_token = user.github_access_token
      Strano.stub(:base_url).and_return('http://example.com/listener')
      @project = Project.new :url => url
    end

    context "is nil", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      it { @project.github.should_not_receive(:hook) }
    end

    context "is not nil", :vcr => { :cassette_name => 'Github_Repo/_repo' } do
      before(:each) do
        Strano.stub(:base_url).and_return('http://example.com/listener')
      end

      it { @project.github.should_receive(:hook) }
    end

    after(:each) do
      @project.save
    end
  end
end
