require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

if Spork.using_spork?
# Spork.prefork do
#   ActiveSupport::Dependencies.clear
# end

Spork.each_run do
  Dir["#{Rails.root}/app/**/*.rb",
      "#{Rails.root}/spec/s*/*.rb",
      "#{Rails.root}/spec/c*/*.rb",
    ].each { |f| load f }
end

end


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/factories"
  config.use_transactional_fixtures = true
  config.include Devise::TestHelpers, :type => :controller
end

