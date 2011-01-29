namespace :heroku do

  desc 'Info about setting up heroku'
  task :info do
    puts 'INFORMATION ABOUT HOW TO SETUP HEROKU'
    puts 'heroku plugins:install git://github.com/ddollar/heroku-accounts.git'
    puts "heroku create APPLICATION --stack bamboo-mri-1.9.2"
    puts "heroku sharing:add anders@janmyr.com"
    puts "heroku keys:add"
    puts 'heroku config:add BUNDLE_WITHOUT="development:test"'
    puts "heroku addons:add custom_domains"
    puts "heroku domains:add helios.jayway.com"
    puts <<-GIT_INFO
      # Add this to your git/config
      [remote "heroku"] 
        url = git@heroku.com:helios-server.git
        fetch = +refs/heads/*:refs/remotes/heroku/*
    GIT_INFO

    
    
  end
    
end

