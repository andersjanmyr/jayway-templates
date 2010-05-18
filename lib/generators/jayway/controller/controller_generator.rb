require 'generators/jayway'
require 'rails/generators/named_base'

module Jayway
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      extend TemplatePath
      attr_accessor :attributes
      
      argument :actions, :type => :array, :default => [], :banner => "action action"

      def create_view_files
        base_path = File.join("app/views", class_path, file_name)
        empty_directory base_path

        actions.each do |action|
          @action = action
          @path   = File.join(base_path, "#{action}.html.haml")
        
          begin
            find_in_source_paths("#{action}.haml.erb") 
            template_name = "#{action}.haml.erb"   
          rescue
            template_name = 'empty.haml.erb'
          end
          template template_name, @path
        end
      end
      
      
      
    end
  end
end