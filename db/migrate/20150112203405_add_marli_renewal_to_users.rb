class AddMarliRenewalToUsers < ActiveRecord::Migration
  def up
    add_column :users, :marli_renewal, :text
    say_with_time "Migrating Marli Renewal status." do
      User.all.each do |user|
        user.update_attribute :marli_renewal,  user.user_attributes[:marli_renewal] unless user.user_attributes.nil?
      end
    end
  end

  def down
    remove_column :users, :marli_renewal
  end
end
