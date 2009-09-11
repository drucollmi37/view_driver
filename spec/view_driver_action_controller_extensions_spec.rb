require File.dirname(__FILE__) + '/spec_helper'
  
describe ActionController do
  include ViewDriverSpecHelper
  
  context "default_section_templates" do
    before :each do
      @controller = create_controller
      @controller.action_name = 'show'
      @default_section_templates = ['pages/show_sidebar', 'pages/default_sidebar', "#{ViewDriver::SECTIONS_DIR}/default_sidebar"]
    end
    
    it "should return default templates" do
      @controller.default_section_templates(:sidebar).should == @default_section_templates
      @controller.class.default_section_templates(:sidebar, 'show').should == @default_section_templates
    end
  end
  
  context "sections" do
    it "should define sections" do
      @controller = create_controller do
        sections :sidebar => 'show'
      end
    
      get 'index'
      @controller.assigns["sections_collection"].should == (ViewDriver::SectionsCollection.new(@controller) << ViewDriver::Sections.new(nil, {:sidebar => 'show'}))
    end
    
    it "should define multiple sections" do
      @controller = create_controller('admin/pages') do
        sections :sidebar => 'show'
        sections :header => 'default'
      end
    
      get 'index'
      @controller.assigns["sections_collection"].should == (ViewDriver::SectionsCollection.new(@controller) << ViewDriver::Sections.new(nil, {:sidebar => 'show'}) << ViewDriver::Sections.new(nil, {:header => 'default'}))
    end
    
    it "should define sections using proc" do
      @controller = create_controller do
        sections proc{|c| "users/#{c.action_name}" }
      end

      get 'index'
      @controller.assigns["sections_collection"].should == (ViewDriver::SectionsCollection.new(@controller) << ViewDriver::Sections.new('users/index'))
    end
    
    it "should define sections using method" do
      @controller = create_controller do
        sections :change_sections

        define_method 'change_sections' do 
          "users/#{action_name}"
        end
      end

      get 'index'
      @controller.assigns["sections_collection"].should == (ViewDriver::SectionsCollection.new(@controller) << ViewDriver::Sections.new('users/index'))
    end
  end
  
  context "sublayout" do
    it "should define sublayout" do
      @controller = create_controller do
        sublayout 'particular'
      end
    
      get 'index'
      @controller.assigns["sublayout"].should == 'particular'
    end
  
    it "should define sublayout using proc" do
      @controller = create_controller do
        sublayout proc{|c| "#{c.action_name}_particular"}
      end
    
      get 'index'
      @controller.assigns["sublayout"].should == 'index_particular'
    end
  
    it "should define sublayout using method" do
      @controller = create_controller do
        sublayout :change_sublayout
      
        define_method 'change_sublayout' do 
          "#{action_name}_particular"
        end
      end
    
      get 'index'
      @controller.assigns["sublayout"].should == 'index_particular'
    end
  end
end
