class AddPatronStatusToUser < ActiveRecord::Migration
  def up
    add_column :users, :patron_status, :string
    say_with_time "Migrating Patron Status." do
      User.all.each do |user|
        user.update_attribute :patron_status,  user.user_attributes[:bor_status] unless user.user_attributes.nil?
      end
    end
  end

  def down
    remove_column :users, :patron_status
  end
end
