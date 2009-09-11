require File.dirname(__FILE__) + '/spec_helper'
  
describe ViewDriver::SectionsCollection do
  include ViewDriverSpecHelper
  
  before :each do
    @controller = create_controller
    @controller.action_name = 'show'
    @collection = ViewDriver::SectionsCollection.new(@controller)
  end
  
  context "defined_template" do
    it "should return nil when collection is blank" do
      @collection.defined_template(:sidebar).should be_nil
    end
    
    it "should return last value when only there was only one controller involved" do
      @collection << ViewDriver::Sections.new('show', {})
      @collection.defined_template(:sidebar).should == 'pages/show_sidebar'
    end
    
    context "with multiple sections" do
      it "should return last not null value" do
        @collection << ViewDriver::Sections.new('show', {})
        @collection << ViewDriver::Sections.new(:sidebar => 'new')
        @collection.defined_template(:sidebar).should == 'pages/new_sidebar'
        @collection.defined_template(:subnavi).should == 'pages/show_subnavi'
      end
      
      it "should return false value as last" do
        @collection << ViewDriver::Sections.new(:sidebar => 'new')
        @collection << ViewDriver::Sections.new(:sidebar => false)
        @collection.defined_template(:sidebar).should be_false
      end
    end
  end
  
  context "templates" do
    it "should return empty collection if section is set to false" do
      @collection << ViewDriver::Sections.new(false, {})
      @collection.templates(:sidebar).should be_empty
    end
    
    it "should return default templates if sections aren't set" do
      @collection.templates(:sidebar).should == @controller.default_section_templates(:sidebar)
    end
    
    context "with defined sections" do
      before :each do
        @collection << ViewDriver::Sections.new(nil, {:sidebar => 'users/show'})
      end
    
      it "should return a template defined by section + default templates for defined section" do
        @collection.templates(:sidebar).should == ['users/show_sidebar'] + @collection.controller.default_section_templates(:sidebar)
      end
      
      it "should return default templates for undefined section" do
        @collection.templates(:header).should == @controller.default_section_templates(:header)
      end
    end
    
    context "with multi defined sections" do
      it "should return defined template + default templates" do
        @collection << ViewDriver::Sections.new('create')
        @collection << ViewDriver::Sections.new(nil, {:sidebar => 'new'})
        
        @collection.templates(:header).should == ['pages/create_header'] + @controller.default_section_templates(:header)
        @collection.templates(:sidebar).should == ['pages/new_sidebar']  + @controller.default_section_templates(:sidebar)
      end
    end
  end
  
  context 'template_to_render' do
    it "should return first existing template" do
      @collection << ViewDriver::Sections.new('create')
      @collection.should_receive(:template_exists?).with('pages/create_sidebar').and_return(true)
      @collection.template_to_render(:sidebar).should == 'pages/create_sidebar'
    end
    
    it "should return nil if there weren't any templates" do
      @collection.should_receive(:templates).with(:header).and_return([])
      @collection.template_to_render(:header).should be_nil
    end
    
    it "should return nil if there weren't any existing templates" do
      @collection.should_receive(:template_exists?).exactly(3).and_return(false)
      @collection.template_to_render(:sidebar).should be_nil
    end
  end
  
end