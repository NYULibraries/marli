class AddSchoolToUsers < ActiveRecord::Migration
  def up
    add_column :users, :school, :string
    say_with_time "Migrating User school." do
      User.all.each do |user|
        user.update_attribute :school,  user.user_attributes[:school] unless user.user_attributes.nil?
      end
    end
  end

  def down
    remove_column :users, :school
  end
end
