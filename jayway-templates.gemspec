# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
  
Gem::Specification.new do |s|
  s.name        = "jayway-templates"
  s.version     = 1.0
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Anders Janmyr"]
  s.email       = ["anders.janmyr@jayway.com"]
  s.homepage    = "http://github.com/andersjanmyr/jayway-templates"
  s.summary     = "Common Rails templates and generators for Jayway"
  s.description = s.summary
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.add_development_dependency "formtastic"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.require_path = 'lib'
end