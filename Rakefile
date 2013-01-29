#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)

Marli::Application.load_tasks

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "MaRLI"
  rdoc.options << '--line-numbers'
  rdoc.options << '--markup markdown'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('app/**/*.rb')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
