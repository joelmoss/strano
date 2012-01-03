require "spec_helper"

describe Github do

  let!(:github) { Github.new('somerandomstring') }

  describe ".new" do
    it "should define the access token" do
      github.instance_variable_get("@access_token").should == 'somerandomstring'
    end
  end

  describe "#user" do
    it { github.user.should be_a(Github::User) }
  end

  describe "#key" do
    it { github.key.should be_a(Github::Key) }
  end

  describe "#repo" do
    it { github.repo('bob', 'bobsrepo').should be_a(Github::Repo) }
  end

end