source 'https://rubygems.org'

gem 'rails', '~> 4.2.5'

# Use MySQL for the database
gem 'mysql2', '~> 0.4.9'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.6'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.2'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 4.3.1'

# Use jQuery UI was well
gem 'jquery-ui-rails', '~> 6.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.2.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# If you can't install this locally on Mac OS X use the following command
# gem install libv8 -v '3.16.14.11' -- --with-system-v8
gem 'therubyracer', '~> 0.12'

# Use Exlibris::Nyu for NYU Exlibris customizations, etc.
gem 'exlibris-nyu', github: 'NYULibraries/exlibris-nyu', tag: 'v2.4.0'

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 3.0.2'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries_errors', github: 'NYULibraries/nyulibraries_errors', tag: 'v1.0.1'
gem 'nyulibraries_stylesheets', github: 'NYULibraries/nyulibraries_stylesheets', tag: 'v1.0.1'
gem 'nyulibraries_javascripts', github: 'NYULibraries/nyulibraries_javascripts', tag: 'v1.0.0'
gem 'nyulibraries_templates', github: 'NYULibraries/nyulibraries_templates', tag: 'v1.0.1'
gem 'nyulibraries_institutions', github: 'NYULibraries/nyulibraries_institutions', tag: 'v1.0.1'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.7.1'
gem 'omniauth-nyulibraries', github: 'NYULibraries/omniauth-nyulibraries', tag: 'v2.1.1'
gem 'devise', '~> 4.3.0'

# Use Kaminari for pagination
gem 'kaminari', '~> 1.0.0'

gem 'acts_as_indexed', '~> 0.8.0'

# For memcached
gem 'dalli', '~> 2.7.6'

# Create CSVs from models
gem 'comma', '~> 4.1.0'

gem 'httparty', '~> 0.15.0'

gem 'roboto', '~> 1'

group :development do
  gem 'better_errors', '~> 2.3.0'
  gem 'binding_of_caller', '~> 0.7.2'
end

group :development, :test do
  # Use pry as the REPL
  gem 'pry', '~> 0.10.1'
end

group :test do
  # Use Coveralls.io to track testing coverage
  gem 'coveralls', '~> 0.8.0', :require => false
  # Use VCR with WebMock for testing with deterministic HTTP interactions
  gem 'vcr', '~> 3.0'
  gem 'webmock', '~> 3.0'
  gem 'faker'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'cucumber-rails', '~> 1.5.0', require: false
  gem 'database_cleaner'
  gem 'phantomjs', '>= 1.9.0'
  gem 'poltergeist', '~> 1.16.0'
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-its'
end
