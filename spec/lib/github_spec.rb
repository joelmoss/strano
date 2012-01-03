require "spec_helper"

describe Github do

  let!(:github) { Github.new('somerandomstring') }

  describe ".new" do
    it "should define the access token" do
      github.instance_variable_get("@access_token").should == 'somerandomstring'
    end
  end

end