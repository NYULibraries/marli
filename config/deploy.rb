# Default require
require 'formaggio/capistrano'
set :app_title, "marli"
# Do not use new_relic at this time
set :new_relic_environments, nil
# Run using ruby 2.1.3
set :rvm_ruby_string, "ruby-2.1.3"
set :assets_gem, ["nyulibraries_stylesheets.git", "nyulibraries_javascripts.git"]
