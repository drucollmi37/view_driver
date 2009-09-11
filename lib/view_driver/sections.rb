module ViewDriver
  class Sections
    attr_reader :templates
    
    def initialize(default_value, options = {})
      @templates = convert_to_hash(default_value, options)
    end
    
    def template(section)
      @templates[section].normalized_section_template(section)
    end
    
    def ==(sections)
      @templates == sections.templates && @templates.default == sections.templates.default
    end
    
    private
        
    def convert_to_hash(default_value, options)
      raise(ArgumentError, "No arguments were provided") if default_value.nil? && options.blank?
      
      hash = case default_value
        when Hash, HashWithIndifferentAccess
          HashWithIndifferentAccess.new.merge(default_value)
        when String, NilClass, FalseClass
          HashWithIndifferentAccess.new(default_value)
        else
          raise(ArgumentError, 'Unsupported argument')
      end
      # using merge! because simple merge deletes default value
      hash.merge!(options)
    end
    
  end
end