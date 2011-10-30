source 'http://rubygems.org'

gem 'rails', '3.0.7'
gem 'haml' 
# Added below rake version, as 0.9.0 not working
gem 'rake', '~>0.8.7'   #Ravi
#gem 'rake', '0.9.0'   #Ravi

gem 'mime-types'
gem 'mysql'
gem 'will_paginate'
#gem 'authlogic'
gem "authlogic", :git => "git://github.com/odorcicd/authlogic.git", :branch => "rails3"
gem 'cancan'

# For Search Functionality
# Require Sphinx to be installed on system
# sudo apt-get install sphinxsearch
gem 'thinking-sphinx', '2.0.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "jquery-rails"
#gem 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
#gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

#gem 'simple-navigation', '~>3.0.2'   #Ravi
gem 'simple-navigation', '3.5.0'    #Ravi
# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:

gem "spreadsheet", "~> 0.6.5.7"

group :development, :test do
#  gem 'webrat'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
end

group :development do
#  gem 'annotate'
#  gem 'annotate-models'
  gem 'rspec-rails'
end

group :test do 
  gem 'rspec'
end
