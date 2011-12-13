require 'spec_helper'

describe Strano::Repo do

  include FakeFS::SpecHelpers
  
  ENV['STRANO_CLONE_PATH'] = '/test/path/to/repos'
  
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
    it { repo.path.should == '/test/path/to/repos/joelmoss/strano' }
  end
  
  describe "#git" do
    it { repo.git.should be_a(Grit::Git) }
  end
  
  describe ".clone" do
    let(:url) { 'git@github.com:joelmoss/strano.git' }
    let(:path) { '/test/path/to/repos/joelmoss/strano' }
    
    it "should clone a github repository to STRANO_CLONE_PATH" do
      Grit::Git.any_instance.should_receive(:clone).with({}, url, path)
      Strano::Repo.clone(url).should be_a(Strano::Repo)
    end
  end
  
end