source 'https://rubygems.org'

gem 'rails', '~> 3.2.16'

gem 'mysql2', '~> 0.3.11'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '~> 0.12.0', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'compass', '~> 0.12.1'
  gem 'compass-rails', '~> 1.0.3'
  gem 'yui-compressor', '~> 0.12.0'
end

group :test do
  #Testing coverage
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'vcr', '~> 2.6.0'
  gem 'webmock', '~> 1.14.0'
  gem 'coveralls', '~> 0.7.0', :require => false
end

# Aleph config gem

gem 'json', '~> 1.8.0'

gem 'debugger', :groups => [:development, :test, :staging]

gem 'exlibris-nyu', :git => 'git://github.com/NYULibraries/exlibris-nyu.git', :tag => 'v1.1.2'
gem 'authpds-nyu', :git => 'git://github.com/NYULibraries/authpds-nyu.git', :tag => 'v1.1.2'
gem 'nyulibraries_assets', :git => 'git://github.com/NYULibraries/nyulibraries_assets.git', :tag => 'v1.2.0'
gem 'nyulibraries_deploy', :git => 'git://github.com/NYULibraries/nyulibraries_deploy.git', :tag => 'v3.2.0'

gem 'jquery-rails', '~> 3.0.4'
gem 'jquery-ui-rails', '~> 4.1.0'
  
gem 'rails_config', '~> 0.3.3'

gem 'kaminari', '~> 0.15.0'

gem 'newrelic_rpm', '~> 3.6.0'

gem 'mustache', '0.99.4'
gem 'mustache-rails', '~> 0.2.3', :require => 'mustache/railtie'

# For memcached
gem 'dalli', '~> 2.6.2'

# Create CSVs from models
gem 'comma', '~> 3.2.0'

gem 'httparty', '~> 0.11.0'