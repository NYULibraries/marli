class AddOverrideAccessToUsers < ActiveRecord::Migration
  def up
    add_column :users, :override_access, :boolean
    say_with_time "Migrating Marli Exception Status." do
      User.all.each do |user|
        user.update_attribute :override_access,  user.user_attributes[:marli_exception] unless user.user_attributes.nil?
      end
    end
  end

  def down
    remove_column :users, :override_access
  end
end
