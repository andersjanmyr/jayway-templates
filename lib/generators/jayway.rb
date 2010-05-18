module Jayway
  module Generators
    module TemplatePath
      def source_root
        @_jayway_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'jayway', 'templates'))
      end
    end
  end  
end