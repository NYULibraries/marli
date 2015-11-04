source 'https://rubygems.org'

gem 'rails', '~> 4.1.11'

# Use MySQL for the database
gem 'mysql2', '~> 0.3.17'

# Use SCSS for stylesheets
gem 'sass-rails', '5.0.0.beta1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 3.1.2'

# Use jQuery UI was well
gem 'jquery-ui-rails', '~> 5.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.7.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# If you can't install this locally on Mac OS X use the following command
# gem install libv8 -v '3.16.14.11' -- --with-system-v8
gem 'therubyracer', '~> 0.12'

# Use Exlibris::Nyu for NYU Exlibris customizations, etc.
gem 'exlibris-nyu', github: 'NYULibraries/exlibris-nyu', tag: 'v2.1.3'

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 2.0.1'

# Use mustache for templating
# Fix to 0.99.4 cuz 0.99.5 broke my shit.
gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'NYULibraries/mustache-rails', require: 'mustache/railtie', tag: 'v0.2.3'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries-assets', github: 'NYULibraries/nyulibraries-assets', tag: 'v4.4.3'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.5.2'
gem 'omniauth-nyulibraries', github: 'NYULibraries/omniauth-nyulibraries', tag: 'v2.0.0'
gem 'devise', '~> 3.4.1'

# Use Figs for setting the configuration in the Environment
gem 'figs', '~> 2.0.2'

# Use Kaminari for pagination
gem 'kaminari', '~> 0.16.1'

# For memcached
gem 'dalli', '~> 2.7.2'

# Create CSVs from models
gem 'comma', '~> 3.2.2'

gem 'httparty', '~> 0.13.3'

group :development do
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller', '~> 0.7.2'
end

group :development, :test do
  # Use pry as the REPL
  gem 'pry', '~> 0.10.1'
end

group :test do
  # Use Coveralls.io to track testing coverage
  gem 'coveralls', '~> 0.7.2', :require => false
  # Use VCR with WebMock for testing with deterministic HTTP interactions
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.20.4'
  gem 'faker'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'phantomjs', '>= 1.9.0'
  gem 'poltergeist', '~> 1.6.0'
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 2.99.0'
end
