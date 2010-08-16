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
# run 'gem install rspec-rails --pre'
gem 'rspec', '>= 2.0.0.beta.19', :group => :test
gem 'rspec-rails', '>= 2.0.0.beta.19', :group => :test
gem 'factory_girl', :git => 'git://github.com/szimek/factory_girl.git', :branch => 'rails3', :group => :test

# Cucumber integration test
gem 'capybara', :group => :test
gem 'database_cleaner', :group => :test
gem 'cucumber-rails', :group => :test
gem 'cucumber', :group => :test
gem 'spork', :group => :test
gem 'launchy', :group => :test
gem 'cucumber', :group => :test

# Install View
gem 'haml'
gem 'jayway-templates', :git => 'http://github.com/andersjanmyr/jayway-templates.git'
gem 'formtastic', :git => 'http://github.com/justinfrench/formtastic.git', :branch => 'rails3'
get 'http://github.com/justinfrench/formtastic/raw/master/generators/formtastic/templates/formtastic.rb', 'config/initializers/formtastic.rb'
gem 'responders'

# Authentication
gem 'devise', '1.1.rc2'

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
  %body.bp
    #container.showgrid
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
get 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.js', 'public/javascripts/jquery-ui.js'
get 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js', 'public/javascripts/jquery-ui.min.js'
get 'http://github.com/rails/jquery-ujs/raw/master/src/rails.js', 'public/javascripts/rails.js'

# Configure Rails Generators
application <<-GENERATORS
    config.generators do |g| 
      g.orm  :active_record  
      g.scaffold_controller :responders_controller  
      g.template_engine :jayway  
      g.test_framework :rspec, :fixture => true, :views => false, :view_specs => false 
      g.integration_tool :cucumber
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.stylesheets false
    end 
GENERATORS

# RVM
file ".rvmrc", <<-RVMRC
rvm gemset use #{app_name}
RVMRC

current_ruby =  /^(.*):/.match(%x{rvm info})[1]
run "rvm gemset create #{app_name}"
run "rvm #{current_ruby}@#{app_name} gem install bundler"
run "rvm #{current_ruby}@#{app_name} -S bundle install"

# Run the generators
run "rvm #{current_ruby}@#{app_name} -S rails g responders:install"
run "rvm #{current_ruby}@#{app_name} -S rails g rspec:install"
run "rvm #{current_ruby}@#{app_name} -S rails g cucumber:install --rspec --capybara"  
run "rvm #{current_ruby}@#{app_name} -S compass create . --using blueprint/semantic --app rails --sass-dir app/stylesheets --css-dir public/stylesheets" 

# Replace the compass/blueprint stylesheets
remove_file 'app/stylesheets/partials/_two_col.scss'

remove_file 'app/stylesheets/ie.scss'
file 'app/stylesheets/ie.scss', <<-IE_SCSS
@import "blueprint";

//@include blueprint-ie;
IE_SCSS

remove_file 'app/stylesheets/partials/_base.scss'
file 'app/stylesheets/partials/_base.scss', <<-BASE_SCSS
$blueprint_liquid_grid_columns: 24;
$blueprint_liquid_container_width: 80%;
$blueprint_liquid_container_min_width: 950px;
BASE_SCSS

remove_file 'app/stylesheets/partials/_form.scss'
file 'app/stylesheets/partials/_form.scss', <<-FORM_SCSS
form {
  @include column(16);
  @include append(8);
  @include last;
  @include blueprint-form;  
}

form label {
  display:block;
}

form li {
  list-style: none;
}
FORM_SCSS

remove_file 'app/stylesheets/partials/_page.scss'
file 'app/stylesheets/partials/_page.scss', <<-PAGE_SCSS
@import "blueprint/debug";

@include sticky-footer(54px, "#container", "#container-footer", "#footer");

body.bp {
  @include blueprint-typography(true);
  @include blueprint-utilities;
  @include blueprint-debug;
  @include blueprint-interaction; 

  #container {
    @include column(24, true);
    #header {
      @include column(24, true);    
    }
    #sidebar {
      @include column(4);
    }

    #content {
      @include column(20, true);
    }
    #container-footer {
      @include column(24, true);
    }
  }
  #footer {
    @include column(24, true);
  }
}
PAGE_SCSS

remove_file 'app/stylesheets/print.scss'
file 'app/stylesheets/print.scss', <<-PRINT_SCSS
@import "blueprint";

body.bp {
  @include blueprint-print(true); }
PRINT_SCSS

remove_file 'app/stylesheets/screen.scss'
file 'app/stylesheets/screen.scss', <<-SCREEN_SCSS
@import "blueprint/reset";

@import "partials/base"; // Load before blueprint, configures variables

@import "compass/layout";
@import "blueprint";

@import "partials/page";
@import "partials/form";
SCREEN_SCSS


# Git
run 'touch db/.gitkeep lib/tasks/.gitkeep log/.gitkeep tmp/.gitkeep public/stylesheets/.gitkeep vendor/plugins/.gitkeep'

append_file '.gitignore' , <<-GIT 
.DS_Store
.bundle
.idea
db/*.sqlite3
log/*.log
public/stylesheets/*.css
tmp/**/*
GIT

git :init
git :add => '.'
git :commit => '-a -m "Initial commit"'
