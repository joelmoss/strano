require 'spec_helper'

describe Strano::Repo do

  include FakeFS::SpecHelpers

  let(:url) { 'git@github.com:joelmoss/strano.git' }
  let(:repo) { Strano::Repo.new('git@github.com:joelmoss/strano.git') }

  describe "#ssh_url" do
    it "should be extracted from repo URL" do
      repo.ssh_url.should == 'git@github.com:joelmoss/strano.git'
    end
  end

  describe "#user_name" do
    it "should be extracted from repo URL" do
      repo.user_name.should == 'joelmoss'
    end
  end

  describe "#repo_name" do
    it "should be extracted from repo URL" do
      repo.repo_name.should == 'strano'
    end
  end

  describe "#path" do
    it { repo.path.should == "#{REPO_ROOT}/joelmoss/strano" }
  end

  describe "#git" do
    it { repo.git.should be_a(Grit::Git) }
  end

  describe ".clone" do
    let(:path) { "#{REPO_ROOT}/joelmoss/strano" }

    it "should clone a github repository" do
      Grit::Git.any_instance.should_receive(:clone).with({:timeout => false}, url, path)
      Strano::Repo.clone(url).should be_a(Strano::Repo)
    end
  end

  describe ".remove" do
    let(:path) { "#{REPO_ROOT}/joelmoss/strano" }

    before(:each) do
      Grit::Git.any_instance.should_receive(:fs_delete).with('../')
      Grit::Git.any_instance.should_receive(:fs_exist?).with('../').and_return(false)
    end

    it { Strano::Repo.remove(url).should == true }
  end

  describe "#cloned?" do
    before(:each) { FakeFS.deactivate! }

    it { repo.cloned?.should == true }

    context "when project is not cloned" do
      let(:repo) { Strano::Repo.new('git@github.com:joelmoss/null.git') }

      it { repo.cloned?.should == false }
    end
  end

  describe "#capified?" do
    before(:each) { FakeFS.deactivate! }

    it { repo.capified?.should == true }

    context "when project is not capified" do
      let(:repo) { Strano::Repo.new('git@github.com:joelmoss/uncapified.git') }

      it { repo.capified?.should == false }
    end
  end

end