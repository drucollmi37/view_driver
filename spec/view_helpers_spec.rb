require File.dirname(__FILE__) + '/spec_helper'

describe ViewDriver::ViewHelpers do
  include ViewDriver::ViewHelpers
  include ViewDriverSpecHelper
  
  context "render_section" do
    before(:each) do
      @controller = create_controller
      @sections_collection = ViewDriver::SectionsCollection.new(@controller)
    end
    
    it "should return nil if no templates available" do
      @sections_collection.should_receive(:template_to_render).with(:sidebar).and_return(nil)
      render_section(:sidebar).should be_nil
    end
    
    it "should return rendered template" do
      @sections_collection.should_receive(:template_to_render).with(:sidebar).and_return('pages/default_sidebar')
      should_receive(:render).with(:file => 'pages/default_sidebar').and_return('rendered pages/default_sidebar')
      render_section(:sidebar).should == 'rendered pages/default_sidebar'
    end
  end
  
  context "yield_with_sublayouts" do
    it "should return @content_for_layout if sublayout wasn't defined" do
      yield_with_sublayouts.should be_nil
    end
    
    it "should return rendered template" do
      @sublayout = 'default'
      should_receive(:render).with(:file => File.join(ViewDriver::SUBLAYOUTS_DIR, 'default')).and_return('rendered sublayout')
      yield_with_sublayouts.should == 'rendered sublayout'
    end
  end
  
  context "classes" do
    it "should return default classes" do
      classes("default1", "default2").should == "default1 default2"
    end
  
    it "should return default classes and classes whose conditions were true" do
      classes("default", ["one", true], ["two", false]).should == "default one"
    end
  
    it "should return nil if all the conditions were false" do
      classes(["one", false], ["two", false]).should be_nil
    end
  
    it "should return nil if nothing has been provided" do
      classes.should be_nil
    end
  
    it "should raise an error if zero or more than 2 elements have been provided" do
      lambda do
        classes([])
      end.should raise_error(ArgumentError)
      lambda do
        classes('class', ['1', '2', '3'])
      end.should raise_error(ArgumentError)
    end
  end
  
  context "image_tag" do
    it "should include empty alt tag" do
      image_tag('i.gif').should include('alt=""')
    end
    
    it "should duplicate alt's value to title" do
      image_tag('i.gif', :alt => 'alt').should include('alt="alt"')
      image_tag('i.gif', :alt => 'alt').should include('title="alt"')
    end
    
    it "should set title's own value" do
      image_tag('i.gif', :title => 'title').should include('alt=""')
      image_tag('i.gif', :title => 'title').should include('title="title"')
    end
  end
end
