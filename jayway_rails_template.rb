# Setup git 
run "touch db/.gitkeep lib/tasks/.gitkeep log/.gitkeep tmp/.gitkeep public/stylesheets/.gitkeep vendor/plugins/.gitkeep"

append_file '.gitignore' , <<-EOT 
.DS_Store
.bundle
db/*.sqlite3
log/*.log
tmp/**/*
.idea
EOT


# Replace test framework
run "rm -r test"
# run "gem install rspec-rails --pre"
gem "rspec-rails", ">= 2.0.0.beta.8"
run "script/rails g rspec:install"
gem "factory_girl", :git => "git://github.com/szimek/factory_girl.git", :branch => "rails3"

# Install View
gem "haml", '3.0.0.rc.5'
run "haml --rails ."
gem 'rails3-generators', :git => 'http://github.com/andersjanmyr/rails3-generators.git'
gem "formtastic", :git => 'http://github.com/justinfrench/formtastic.git', :branch => 'rails3'
run "curl -L http://github.com/justinfrench/formtastic/raw/master/generators/formtastic/templates/formtastic.rb > config/initializers/formtastic.rb"

run "rm app/views/layouts/application.html.erb"
file 'app/views/layouts/application.html.haml' , <<-EOT 
!!!
%html
  %head
    %title Jay
    = stylesheet_link_tag 'application.css'
    = javascript_include_tag 'jquery', 'rails'
    = csrf_meta_tag
  %body
    = yield
EOT

file 'public/stylesheets/sass/application.sass', <<-EOT
@import formtastic_base.sass
.formtastic
  +float-form
EOT

run "curl -L http://github.com/activestylus/formtastic-sass/raw/master/_formtastic_base.sass > public/stylesheets/sass/_formtastic_base.sass"
run "curl -L http://github.com/activestylus/formtastic-sass/raw/master/_skintastic.sass > public/stylesheets/sass/_skintastic.sass"


# Configure Rails
config_text = <<-EOT 
    config.generators do |g| 
      g.orm  :active_record  
      g.template_engine :formtastic_haml  
      g.test_framework  :rspec, :fixture => true 
      g.fixture_replacement :factory_girl
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



