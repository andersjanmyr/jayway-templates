# Application template for Jayway projects

#Development
gem "ruby-debug19", :group => :development
gem 'looksee', :group => :development
gem 'wirble', :group => :development
gem 'hirb', :group => :development
gem 'map_by_method', :group => :development
gem 'what_methods', :group => :development
gem 'awesome_print', :group => :development

# Replace test framework
remove_dir 'test'
gem 'rspec', :group => :test
gem 'rspec-rails', :group => :test
gem 'factory_girl_rails', :group => :test, :git => 'http://github.com/msgehard/factory_girl_rails.git'

# Cucumber integration test
gem 'capybara', :group => :test
gem 'database_cleaner', :group => :test
gem 'spork', :group => :test
gem 'launchy', :group => :test

# Install View
gem 'haml'
gem 'haml-rails'
gem 'simple_form'
gem 'responders'

# Authentication
gem 'devise', '>= 1.1.rc2'

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml' , <<-HAML
!!!
%html
  %head
    %title= yield(:title)
    = stylesheet_link_tag 'screen.css', :media => 'screen, projection'
    = stylesheet_link_tag 'print.css', :media => 'print'
    /[if lt IE 8]
    = stylesheet_link_tag 'ie.css', :media => 'screen, projection'
    = csrf_meta_tag
    = yield(:head)
  %body
    #container
      #header
        %h1= yield(:title) || "\#{params[:controller].capitalize}"
      #sidebar
        This is the sidebar
      #content
        = yield
      #container-footer
    #footer
      This is the footer
    = javascript_include_tag :jquery
    = javascript_include_tag "\#{params[:controller]}"
HAML


# Replace prototype with jQuery.
initializer 'jquery.rb', <<-JQUERY
if Rails.env.development?
ActionView::Helpers::AssetTagHelper.register_javascript_expansion \
  :jquery => %w(jquery jquery-ui rails)
else
ActionView::Helpers::AssetTagHelper.register_javascript_expansion \
  :jquery => %w(jquery.min jquery-ui.min rails)
end
JQUERY

remove_file 'public/javascripts/controls.js'
remove_file 'public/javascripts/dragdrop.js'
remove_file 'public/javascripts/effects.js'
remove_file 'public/javascripts/prototype.js'
remove_file 'public/javascripts/rails.js'
get 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.js', 'public/javascripts/jquery.js'
get 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js', 'public/javascripts/jquery.min.js'
get 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.js', 'public/javascripts/jquery-ui.js'
get 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js', 'public/javascripts/jquery-ui.min.js'
get 'https://github.com/rails/jquery-ujs/raw/master/src/rails.js', 'public/javascripts/rails.js'

# Configure Rails Generators
application <<-GENERATORS
    config.generators do |g|
      g.orm  :active_record
      g.scaffold_controller :responders_controller
      g.template_engine :haml
      g.test_framework :rspec, :fixture => true, :view_specs => false
      g.integration_tool :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.stylesheets false
    end
GENERATORS

run "gem install bundler"
run "bundle install"

# Run the generators
run "rails g responders:install"
run "rails g simple_form:install"
run "rails g rspec:install"

initializer 'sass.rb', <<-SASS
  Sass::Plugin.options[:template_location] = './app/stylesheets'
SASS


# Git
run 'touch db/.gitkeep lib/tasks/.gitkeep log/.gitkeep tmp/.gitkeep public/stylesheets/.gitkeep vendor/plugins/.gitkeep'

