namespace :marli do

  desc 'Dump from old database schema...'
  namespace :dump do

    task :all => [:exceptions, :admins]

    desc 'Dump all exceptions from database.'
    task :exceptions => :environment do
      File.open("#{Rails.root}/lib/tasks/exceptions.yml", 'w') do |file|
        exceptions = User.where("user_attributes LIKE '%:marli_exception: true%'")
        YAML::dump(exceptions.map(&:username), file)
      end
    end

    desc 'Dump all admins from database'
    task :admins => :environment do
      File.open("#{Rails.root}/lib/tasks/admins.yml", 'w') do |file|
        admins = User.where("user_attributes LIKE '%:marli_admin: true%'")
        YAML::dump(admins.map(&:username), file)
      end
    end

  end

  desc '...and restore into new database schema.'
  namespace :restore do

    task :all => [:exceptions, :admins]

    desc 'Restore exceptions from YAML'
    task :exceptions => :environment do
      exceptions = YAML.load_file("#{Rails.root}/lib/tasks/exceptions.yml")
      exceptions.each do |exception|
        current_user = User.find_by_username(exception)
        current_user.override_access = true
        current_user.save!(:validate => false)
        puts "User #{current_user.username} updated as EXCEPTION"
      end
    end

    desc 'Restore admins from YAML'
    task :admins => :environment do
      admins = YAML.load_file("#{Rails.root}/lib/tasks/admins.yml")
      admins.each do |admin|
        current_user = User.find_by_username(admin)
        current_user.admin = true
        current_user.save!(:validate => false)
        puts "User #{current_user.username} updated as ADMIN"
      end
    end

  end

end
