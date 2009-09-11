begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app"
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
# ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

module ViewDriverSpecHelper 
  def create_controller(controller_path = 'pages', super_class = ApplicationController, &block)
    controller = Class.new(super_class)
    
    controller.class_eval do
      class_eval "def self.controller_path; '#{controller_path}'; end"
      
      %w(index show new).each do |action|
        class_eval <<-EOV, __FILE__, __LINE__
          def #{action}
          end
        EOV
      end
    end
    
    controller.class_eval(&block) if block
    controller.new
  end
end

