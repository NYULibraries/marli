class AddAddressToUsers < ActiveRecord::Migration
  def up
    add_column :users, :address, :text
    say_with_time "Migrating User department." do
      User.all.each do |user|
        user.update_attribute :address,  user.user_attributes[:address] unless user.user_attributes.nil?
      end
    end
  end

  def down
    remove_column :users, :address
  end
end
