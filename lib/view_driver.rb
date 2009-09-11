module ViewDriver
  !defined?(SUBLAYOUTS_DIR)  && SUBLAYOUTS_DIR = 'sublayouts'
  !defined?(SECTIONS_DIR)    && SECTIONS_DIR   = 'sections'
end

require 'view_driver/normalized_section_template'
require 'view_driver/sections'
require 'view_driver/sections_collection'
require 'view_driver/action_controller_extensions'
require 'view_driver/view_helpers'
require 'view_driver/image_tag_extension'