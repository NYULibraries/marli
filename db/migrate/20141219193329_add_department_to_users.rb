class AddDepartmentToUsers < ActiveRecord::Migration
  def up
    add_column :users, :department, :string
    say_with_time "Migrating User department." do
      User.all.each do |user|
        user.update_attribute :department,  user.user_attributes[:department] unless user.user_attributes.nil?
      end
    end
  end

  def down
    remove_column :users, :department
  end
end
