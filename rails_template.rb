# Application template for Jayway projects

# Get Gemfile from github
#
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
  :jquery => 
  %w(http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js
   http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.8/jquery-ui.min.js   
   rails)
end
JQUERY

remove_file 'public/javascripts/controls.js'
remove_file 'public/javascripts/dragdrop.js'
remove_file 'public/javascripts/effects.js'
remove_file 'public/javascripts/prototype.js'
remove_file 'public/javascripts/rails.js'
get 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.js', 'public/javascripts/jquery.js'
get 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.8/jquery-ui.js', 'public/javascripts/jquery-ui.js'
get 'https://github.com/rails/jquery-ujs/raw/master/src/rails.js', 'public/javascripts/rails.js'

# Configure Rails Generators
application <<-GENERATORS
  config.middleware.insert_before(ActionDispatch::Static, Rack::Static,
            :root => "tmp", :urls => ["/stylesheets/screen.css",
            "/stylesheets/print.css", "/stylesheets/ie.css"])
    
  config.generators do |g| g.orm  :active_record
    g.scaffold_controller :responders_controller
    g.template_engine :haml
    g.test_framework :rspec, :fixture => true, :view_specs => false
    g.integration_tool :rspec
    g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    g.stylesheets false
  end
GENERATORS

get 'https://github.com/andersjanmyr/jayway-templates/raw/master/rails/Gemfile'

run "gem install bundler"
run "bundle install"

# Replace test framework
remove_dir 'test'

# Run the generators
run "rails g responders:install"
run "rails g simple_form:install"
run "rails g rspec:install"

# Copy livereload and rspec configs
get 'https://github.com/andersjanmyr/jayway-templates/raw/master/rails/.livereload' 
get 'https://github.com/andersjanmyr/jayway-templates/raw/master/rails/.rspec' 

# Copy the stylesheets
`mkdir -p app/stylesheets`
get 'https://github.com/andersjanmyr/jayway-templates/raw/master/rails/app/stylesheets/mixins.scss', 'app/stylesheets/mixins.scss'
get 'https://github.com/andersjanmyr/jayway-templates/raw/master/rails/app/stylesheets/screen.scss', 'app/stylesheets/screen.scss'
get 'https://github.com/andersjanmyr/jayway-templates/raw/master/rails/app/stylesheets/print.scss', 'app/stylesheets/print.scss'

# Copy the layout template
get 'https://github.com/andersjanmyr/jayway-templates/raw/master/rails/app/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml'

get 'https://github.com/andersjanmyr/jayway-templates/raw/master/rails/spec/spec_helper.rb', 'spec/spec_helper.rb'

initializer 'sass.rb', <<-SASS
Sass::Plugin.options[:template_location] = './app/stylesheets'
Sass::Plugin.remove_template_location('./app/stylesheets')

Sass::Plugin.add_template_location(
  Rails.root.join('./app/stylesheets').to_s,
  Rails.root.join('./tmp/stylesheets').to_s)
SASS

# Copy the lib files


# Git
run 'touch db/.gitkeep lib/tasks/.gitkeep log/.gitkeep tmp/.gitkeep public/stylesheets/.gitkeep vendor/plugins/.gitkeep'

