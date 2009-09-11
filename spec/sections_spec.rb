require File.dirname(__FILE__) + '/spec_helper'
  
describe ViewDriver::Sections do
  include ViewDriverSpecHelper
  
  context "equality" do
    before :each do
      @sections = ViewDriver::Sections.new(nil, {:header => 'show'})
    end
    
    it "should be equal to another object with the same templates" do
      @sections.should == ViewDriver::Sections.new(nil, {:header => 'show'})
    end
    
    it "should not be equal to objects with different templates" do
      @sections.should_not == ViewDriver::Sections.new(false)
      @sections.should_not == ViewDriver::Sections.new(false, {:header => 'show'})
      @sections.should_not == ViewDriver::Sections.new(nil, {:header => 'temp'})
    end
  end
  
  context 'template' do
    it "should return default value for unexisting section" do
      ViewDriver::Sections.new(false).template(:header).should be_false
      ViewDriver::Sections.new(false, {:header => 'users/show'}).template(:sidebar).should be_false
      ViewDriver::Sections.new(nil, {:header => 'users/show'}).template(:sidebar).should be_nil
      ViewDriver::Sections.new("show").template(:sidebar).should == "show_sidebar"
    end
  
    it "should add section's name" do
      ViewDriver::Sections.new(nil, {:header => 'show'}).template(:header).should == "show_header"      
      ViewDriver::Sections.new(nil, {:header => 'users/show'}).template(:header).should == "users/show_header"      
    end
    
    it "should not add section's name" do
      ViewDriver::Sections.new(nil, {:header => 'show_header'}).template(:header).should == 'show_header'
    end
  end
  
end
