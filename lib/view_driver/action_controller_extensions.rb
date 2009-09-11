module ViewDriver
  module ActionControllerExtensions
    FILTER_OPTIONS = [:only, :except, :if, :unless]
    
    def self.included(base)
      base.extend ClassMethods
      base.cattr_accessor :existing_sections
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
    
      # Filter to define sections in a controller
      def sections(*args)
        method = "_sections_#{args.to_s.gsub(/[^a-z_]/, '_')}"
        options = args.extract_options!
        raise(ArgumentError, "Only one argument is allowed") if args.size > 1
      
        before_filter method, options.slice(*FILTER_OPTIONS)
      
        define_method method do        
          @sections_collection ||= SectionsCollection.new(self)
          section_templates = options.except(*FILTER_OPTIONS)
          section_templates.each{|k,v| section_templates[k] = parse_argument_for_sections(v)}
          @sections_collection << Sections.new(parse_argument_for_sections(args.first), section_templates)
        end
      
        protected method.to_sym
      end
    
      # Filter to define a sublayout in a controller
      def sublayout(*args)
        method = "_sublayout_#{args.to_s.gsub(/[^a-z_]/, '_')}"
        options = args.extract_options!
      
        before_filter method, options.slice(*FILTER_OPTIONS)
      
        define_method method do
          @sublayout = case (sublayout = args.first)
            when Symbol
              send(sublayout)
            when Proc
              sublayout.call(self)
            else
              sublayout
          end
        end
        protected method.to_sym
      end
      
      def default_section_templates(section, action_name)
        [action_name, 'default'].map{|action| controller_path + "/#{action}_#{section}"} + [ViewDriver::SECTIONS_DIR + "/default_#{section}"]
      end
      
    end
    
    module InstanceMethods
      
      def default_section_templates(section, action = nil)
        self.class.default_section_templates(section, action || action_name)
      end
      
      def parse_argument_for_sections(arg)
        case arg
          when Symbol
            send(arg)
          when Proc
            arg.call(self)
          when String, NilClass, FalseClass
            arg
          else
            raise ArgumentError, "Unsupported argument"
        end
      end
    end
            
  end
end

ActionController::Base.send(:include, ViewDriver::ActionControllerExtensions)
