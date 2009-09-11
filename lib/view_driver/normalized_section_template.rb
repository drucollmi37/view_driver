module ViewDriver
  module ObjectExtensions
    def normalized_section_template(section)
      self
    end
  end
  
  module StringExtensions
    def normalized_section_template(section)
      self !~ /_#{section}$/ ? self + "_#{section}" : self
    end
  end
end

Object.send :include, ViewDriver::ObjectExtensions
String.send :include, ViewDriver::StringExtensions