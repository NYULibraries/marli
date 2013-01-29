# Load bundler-capistrano gem
require "bundler/capistrano"
# Load rvm-capistrano gem
require "rvm/capistrano"

# Environments
set :stages, ["staging", "production"]
set :default_stage, "staging"
# Multistage
require 'capistrano/ext/multistage'

set :ssh_options, {:forward_agent => true}
set :app_title, "marli"
set :application, "#{app_title}_repos"

# RVM  vars
set :rvm_ruby_string, "1.9.3-p125"

# Bundle vars

# Git vars
set :repository, "git@github.com:NYULibraries/marli.git" 
set :scm, :git
set :deploy_via, :remote_cache
set(:branch, 'master') unless exists?(:branch)
set :git_enable_submodules, 1

set :keep_releases, 5
set :use_sudo, false

# Rails specific vars
set :normalize_asset_timestamps, false

# Deploy tasks
namespace :deploy do
  desc "Start Application"
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  task :passenger_symlink do
    run "rm -rf #{app_path}#{app_title} && ln -s #{current_path}/public #{app_path}#{app_title}"
  end
end

desc "Cleanup git project"
task :clean_git, :roles => :app do
  # Clean up non tracked git files that aren't explicitly ignoredgit 
  system "git clean -d -f"
end

desc "Generate rdocs and push rdocs and coverage to gh-pages"
task :ghpages, :roles => :app do
  #system "bundle exec rake rdoc RAILS_ENV=#{rails_env} && bundle exec rake ghpages RAILS_ENV=#{rails_env}"
end

before "deploy", "rvm:install_ruby", "deploy:migrations"
before "ghpages", "clean_git"
after "deploy", "ghpages", "deploy:cleanup", "deploy:passenger_symlink"
