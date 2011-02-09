## Rails Template

This file contains Rails templates that we use at Jayway. 

It is used to create a new project with Jayway specific defaults. It
creates the Rails structure, runs "bundle install", runs the generators
and then checks it all into a new Git repository. It also downloads
files from this directory for setting up spork and livereload.

## Usage

    rails new NAME -m http://github.com/andersjanmyr/jayway-templates/raw/master/rails_template.rb


## Defaults

### Test

* rpec and rspec-rails, replaces test_unit
* factory_girl replaces yaml-fixtures
* The spec_helper is setup for using Spork.
* An .rspec is created setup for using --drb
* Qunit is installed in `public/javascripts/test`

### View

* HAML replaces ERB
* SimpleForm for forms
* Default templates for all views are in `lib/templates/haml`.
* SASS, with the new dialect SCCS replaces CSS, files are in `app/stylesheets`.
* jQuery and jQuery UI, replaces PrototypeJS

### Layout

The application layout file is setup with a basic structure and
configured for using device.

### Rake 

Two extra tasks are added:

* heroku:info, information about how I usually setup up Heroku
* rspec, since I mistype `rake rspec` instead of `rake spec`

### The Gemfile

The Gemfile contains commonly used gems, `rails_admin` is included but
currently commented out since it is still in active development.

### Heroku

An initializer for setting up SASS with Heroku is included. The Sass
files need to be generated in the tmp directory on Heroku. Additionaly 
Rack::Static middleware is added to tell Rails to server the stylesheets
from this directory.

