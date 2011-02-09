# Application template for Jayway projects

# Get Gemfile from github
#

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
get 'http://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.js', 'public/javascripts/jquery.js'
get 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.8/jquery-ui.js', 'public/javascripts/jquery-ui.js'
get 'https://github.com/rails/jquery-ujs/raw/master/src/rails.js', 'public/javascripts/rails.js'

# QUnit
get 'http://code.jquery.com/qunit/git/qunit.js', 'public/javascripts/test/qunit.js'
get 'http://code.jquery.com/qunit/git/qunit.css', 'public/javascripts/test/qunit.css'

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

def copy_file name
  get "https://github.com/andersjanmyr/jayway-templates/raw/master/rails/#{name}", name
end

copy_file 'Gemfile'

run "gem install bundler"
run "bundle install"

# Replace test framework
remove_dir 'test'

# Run the generators
run "rails g responders:install"
run "rails g simple_form:install"
run "rails g rspec:install"

# Copy livereload and rspec configs
copy_file '.livereload' 
copy_file '.rspec' 

# Copy the stylesheets
`mkdir -p app/stylesheets/`
copy_file 'app/stylesheets/mixins.scss'
copy_file 'app/stylesheets/screen.scss'
copy_file 'app/stylesheets/print.scss'

# Copy the layout template
copy_file 'app/views/layouts/application.html.haml'

# Copy the spec helper
copy_file 'spec/spec_helper.rb'

# Copy the lib files
`mkdir -p lib/tasks/`
copy_file 'lib/tasks/heroku.rake'
copy_file 'lib/tasks/rspec.rake'
`mkdir -p lib/templates/haml/scaffold/`
copy_file 'lib/templates/haml/scaffold/_form.html.haml'
copy_file 'lib/templates/haml/scaffold/index.html.haml'

# Javascript tests
copy_file 'public/javascripts/test/application_test.js'
copy_file 'public/javascripts/test/test.html'

initializer 'sass.rb', <<-SASS
Sass::Plugin.options[:template_location] = './app/stylesheets'
Sass::Plugin.remove_template_location('./app/stylesheets')

Sass::Plugin.add_template_location(
  Rails.root.join('./app/stylesheets').to_s,
  Rails.root.join('./tmp/stylesheets').to_s)
SASS


create_file 'config/s3.yml', <<-S3
development:
  bucket: app-development
  access_key_id: XXXXXXXXXXXXXXXXXXXX
  secret_access_key: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

test:
  bucket: app-test
  access_key_id: XXXXXXXXXXXXXXXXXXXX
  secret_access_key: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

production:
  bucket: app-production
  access_key_id: XXXXXXXXXXXXXXXXXXXX
  secret_access_key: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
S3


# Git
run 'touch db/.gitkeep lib/tasks/.gitkeep log/.gitkeep tmp/.gitkeep public/stylesheets/.gitkeep vendor/plugins/.gitkeep'
run 'git init'

