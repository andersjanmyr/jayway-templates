require 'rails/generators/erb/scaffold/scaffold_generator'

module Jayway
  module Generators
    class JaywayGenerator < Erb::Generators::ScaffoldGenerator

      class_option :views, :type => :array
      
      def self.source_root
        File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end
      
      
      def copy_layout_file
        return unless options[:layout]
        template "layout.haml.erb",
                 File.join("app/views/layouts", controller_class_path, "#{controller_file_name}.html.haml")
      end
      
      def copy_view_files
        views = available_views
        views.delete("index") if options[:singleton]

        views.each do |view|
          template "#{view}.haml.erb", File.join("app/views", controller_file_path, "#{view}.html.haml")
        end
      end
    end
  end
end