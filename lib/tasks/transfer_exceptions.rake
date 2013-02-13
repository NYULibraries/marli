require 'yaml'
namespace :patron_exceptions do
  #Call from production env
  desc "Save patron exceptions in yaml"
  task :write_to_yaml => :environment do
    rs = ActiveRecord::Base.connection.execute("select username, role from patron_exceptions;")
    patron_exceptions = Hash.new
    rs.each do |key,value|
      patron_exceptions.merge!(key.to_s => value.to_s)
    end
    File.open(File.join(Rails.root, "config", "patron_exceptions.yml"), "w") do |f|
      f.write(patron_exceptions.to_yaml)
    end
  end
  
  desc "Transfer patron exceptions from old schema to new schema"
  task :transfer => :environment do
    patrons = YAML.load(File.read(File.join(Rails.root, 'config', 'patron_exceptions.yml')))
    patrons.each do |patron, role|
      user = User.find_or_create_by_username(patron)
      user_attributes = {}
      user_attributes[:marli_admin] = true if role == "admin"
      user_attributes[:marli_exception] = true if role == "exception"
      user.update_attributes(:user_attributes => user_attributes)
    end
  end
end