require "spec_helper"

describe ApplicationHelper do
  
  describe "#title" do
    it "assigns content_for_title" do
      helper.title 'My Title'
      helper.instance_variable_get('@title_for_content').should == 'My Title'
    end
    
    it "returns the passed title" do
      helper.title('My Title').should == 'My Title'
    end
  end
  
  describe "#show_title?" do
    context "when #title has been called with its second argument as false" do
      it "returns false" do
        helper.title 'My Title', false
        helper.show_title?.should == false
      end
    end
    
    context "when #title has been called without its second argument" do
      it "returns false" do
        helper.title 'My Title'
        helper.show_title?.should == true
      end
    end
    
    context "when #title has been called with its second argument as true" do
      it "returns false" do
        helper.title 'My Title', true
        helper.show_title?.should == true
      end
    end
  end
  
  describe "#subtitle" do
    it "assigns content_for_subtitle" do
      helper.subtitle 'My Sub Title'
      helper.instance_variable_get('@subtitle_for_content').should == 'My Sub Title'
    end
    
    it "returns the passed subtitle" do
      helper.subtitle('My Sub Title').should == 'My Sub Title'
    end
  end
  
  describe "#show_subtitle?" do
    context "when #subtitle has been called with its second argument as false" do
      it "returns false" do
        helper.subtitle 'My Sub Title', false
        helper.show_subtitle?.should == false
      end
    end
    
    context "when #subtitle has been called without its second argument" do
      it "returns false" do
        helper.subtitle 'My Sub Title'
        helper.show_subtitle?.should == true
      end
    end
    
    context "when #subtitle has been called with its second argument as true" do
      it "returns false" do
        helper.subtitle 'My Sub Title', true
        helper.show_subtitle?.should == true
      end
    end
  end
  
end