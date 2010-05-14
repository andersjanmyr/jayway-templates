# Setup git 
run "touch db/.gitkeep lib/tasks/.gitkeep log/.gitkeep tmp/.gitkeep public/stylesheets/.gitkeep vendor/plugins/.gitkeep"

append_file '.gitignore' , <<-EOT 
.DS_Store
.bundle
.idea
db/*.sqlite3
log/*.log
public/stylesheets/*.css
tmp/**/*
EOT


# Replace test framework
run "rm -r test"
# run "gem install rspec-rails --pre"
gem "rspec", ">= 2.0.0.beta.8", :group => :test
gem "rspec-rails", ">= 2.0.0.beta.8", :group => :test
gem "factory_girl", :git => "git://github.com/szimek/factory_girl.git", :branch => "rails3", :group => :test

gem 'capybara', :group => :test
gem 'database_cleaner', :group => :test
gem 'cucumber-rails', :group => :test
gem 'cucumber', '0.7.2', :group => :test
gem 'spork', :group => :test
gem 'launchy', :group => :test
gem 'cucumber', :group => :test

# Install View
gem "haml", "3.0.2"
gem 'rails3-generators', :git => 'http://github.com/andersjanmyr/rails3-generators.git'
gem "formtastic", :git => 'http://github.com/justinfrench/formtastic.git', :branch => 'rails3'
run "curl -L http://github.com/justinfrench/formtastic/raw/master/generators/formtastic/templates/formtastic.rb > config/initializers/formtastic.rb"
gem "compass"

run "rm app/views/layouts/application.html.erb"
file 'app/views/layouts/application.html.haml' , <<-EOT 
!!!
%html
  %head
    %title Jay
    = stylesheet_link_tag 'screen.css', :media => 'screen, projection'
    = stylesheet_link_tag 'print.css', :media => 'print'
    /[if lt IE 8]
      = stylesheet_link_tag 'ie.css', :media => 'screen, projection'
    = javascript_include_tag 'jquery', 'rails'
    = csrf_meta_tag
  %body
    = yield
EOT


# Configure Rails
config_text = <<-EOT 
    config.generators do |g| 
      g.orm  :active_record  
      g.template_engine :formtastic_haml  
      g.test_framework  :rspec, :fixture => true 
      g.integration_tool  :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.stylesheets false
    end 
EOT
inject_into_file  "config/application.rb", config_text, :after => "class Application < Rails::Application\n"

# Replace prototype with jQuery.
run "rm public/javascripts/controls.js"
run "rm public/javascripts/dragdrop.js"
run "rm public/javascripts/effects.js"
run "rm public/javascripts/prototype.js"
run "curl -L http://code.jquery.com/jquery-1.4.2.js > public/javascripts/jquery.js"
run "curl -L http://github.com/rails/jquery-ujs/raw/master/src/rails.js > public/javascripts/rails.js"

# Run the generators
run "bundle install"  
generate 'rspec:install'
generate 'cucumber:skeleton', 'rspec', 'capybara'
run "compass create --app rails --sass-dir app/stylesheets --css-dir public/stylesheets ."

# Git
git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"
