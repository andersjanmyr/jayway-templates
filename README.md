## Rails Template
This file contains Rails templates that we use at Jayway. 

It is used to create a new project with Jayway specific defaults. It creates the Rails structure, runs "bundle install", runs the generators and then checks it all into a new Git repository. It also downloads files from this directory for setting up spork and livereload.

### Usage

    rails new NAME -m http://github.com/andersjanmyr/jayway-templates/raw/master/rails_template.rb


### Requirements

### Defaults
#### Test
* rpec and rspec-rails, replaces test_unit
* factory_girl replaces yaml-fixtures
* cucumber is installed for integration testing

#### View
* HAML replaces ERB, the generators are included in this repo
* SimpleForm for forms
* SASS, with the new dialect SCCS replaces CSS
* jQuery and jQuery UI, replaces PrototypJS


