source 'https://rubygems.org'

gem 'rails', '~> 3.2.18'

gem 'mysql2', '~> 0.3.11'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '~> 0.12.0', :platforms => :ruby

  gem 'uglifier', '~> 2.4.0'
  gem 'compass', '~> 0.12.1'
  gem 'compass-rails', '~> 1.1.3'
  gem 'yui-compressor', '~> 0.12.0'
end

group :test do
  #Testing coverage
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'vcr', '~> 2.8.0'
  gem 'webmock', '~> 1.16.0'
  gem 'coveralls', '~> 0.7.0', :require => false
end

# Aleph config gem

gem 'json', '~> 1.8.0'

group :development, :test do
  gem 'pry', '~> 0.10.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem 'exlibris-nyu', :git => 'git://github.com/NYULibraries/exlibris-nyu.git', :tag => 'v1.1.3'
gem 'authpds-nyu', :git => 'git://github.com/NYULibraries/authpds-nyu.git', :tag => 'v1.1.3'
gem 'nyulibraries-assets', :git => 'git://github.com/NYULibraries/nyulibraries-assets.git', :tag => 'v2.1.1'

gem 'jquery-rails', '~> 3.0.4'
gem 'jquery-ui-rails', '~> 4.1.1'

gem 'figs', '~> 2.0.2'
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.0.1'

gem 'kaminari', '~> 0.15.1'

gem 'newrelic_rpm', '~> 3.7.0'

gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'josh/mustache-rails', require: 'mustache/railtie'

# For memcached
gem 'dalli', '~> 2.7.0'

# Create CSVs from models
gem 'comma', '~> 3.2.0'

gem 'httparty', '~> 0.11.0'
