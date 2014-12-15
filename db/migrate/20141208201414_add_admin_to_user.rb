class AddAdminToUser < ActiveRecord::Migration
  def up
    add_column :users, :admin, :boolean
    say_with_time "Migrating Admin Status." do
      User.all.each do |user|
        user.update_attribute :admin,  user.user_attributes[:marli_admin] unless user.user_attributes.nil?
      end
    end
  end

  def down
    remove_column :users, :admin
  end
end
