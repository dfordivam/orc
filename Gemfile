source 'http://rubygems.org'

gem 'rails', '3.0.7'
gem 'haml' 
# Added below rake version, as 0.9.0 not working
#gem 'rake', '~>0.8.7'   #Ravi
gem 'rake', '0.9.2'   #Divam- Please dont change this

gem 'mime-types'
gem 'mysql'
gem 'will_paginate'
gem 'authlogic', "~> 3.1.0"
gem 'cancan'

# For Search Functionality
# Require Sphinx to be installed on system
# sudo apt-get install sphinxsearch
gem 'thinking-sphinx', '2.0.5'

# For auto complete functionality
gem 'rails3-jquery-autocomplete'
gem 'nifty-generators'

gem "jquery-rails"
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
