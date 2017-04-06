#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)
Marli::Application.load_tasks

if Rails.env.test?
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :default => [:spec, :cucumber, 'coveralls:push']
end
