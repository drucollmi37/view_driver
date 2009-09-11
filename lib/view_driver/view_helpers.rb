module ViewDriver  
  module ViewHelpers
        
    # Renders section :section for the current controller and action
    def render_section(section)
      @sections_collection ||= SectionsCollection.new(@controller)
      
      if RAILS_ENV == "development"
        _time1, _time2 = nil, nil
        _time1 = Time.now
      end
      
      if template = @sections_collection.template_to_render(section)
        result = render(:file => template)
        if RAILS_ENV == "development"
          _time2 = Time.now 
          logger.debug "Rendered section #{template} (#{((_time2 - _time1)*1000).round(1)}ms)"
        end
        result
      elsif RAILS_ENV == "development"
        logger.debug "Missing section #{section}"
        "<!-- Missing section #{section} -->"
      end
    end
    
    # Renders sublayouts
    # replace <%= yield %> or <%= @content_for_layout %> with it to use sublayouts
    def yield_with_sublayouts
      unless @sublayout.blank?
        sublayout_file = @sublayout.include?('/') ? @sublayout : File.join(SUBLAYOUTS_DIR, @sublayout) 
        RAILS_ENV == 'development' && logger.debug("Rendering template within sublayout #{sublayout_file}")
        render :file => sublayout_file
      else
        @content_for_layout
      end
    end
    
    # classes is to set css-classes or other attributes conditionally
    # classes("class-without-conditions", ["logged-class", logged_in?], "third-class-without-conditions")
    def classes(*pairs)
      glued_classes = []
      pairs.map do |pair| 
        arr = Array(pair)
        raise ArgumentError, "css_class or [css_class, condition] are expected (got #{pair.inspect})" if arr.size.zero? || arr.size > 2
        glued_classes << arr[0] if arr[1] || arr.size == 1
      end
      glued_classes.any? ? glued_classes.join(" ") : nil
    end
        
  end
end

ActionView::Base.module_eval do
  include ViewDriver::ViewHelpers
end