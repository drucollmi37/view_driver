module ViewDriver
  
  class SectionsCollection < Array
    attr_reader :controller
    
    def initialize(controller)
      super()
      @controller = controller
    end
    
    def templates(section)
      defined_template = defined_template(section)
      return [] if defined_template == false
      ([defined_template] + @controller.default_section_templates(section)).compact
    end
        
    def defined_template(section)
      template = nil
      each do |sections| 
        candidate = sections.template(section)
        template = candidate unless candidate.nil?
      end
      prepend_controller_path(template)
    end
    
    def prepend_controller_path(template)
      template.is_a?(String) && !template.include?("/") ? File.join(@controller.controller_path, template) : template
    end
    
    def template_to_render(section)
      templates(section).find{|template| template_exists?(template)}
    end
    
    def template_exists?(template)
      file = File.join(RAILS_ROOT, 'app', 'views', template + ".html.erb")
      return File.exists?(file) unless @controller.perform_caching
      ApplicationController.existing_sections ||= {}
      ApplicationController.existing_sections[template] ||= File.exists?(file)
    end
    
  end
end