class RemoveDobFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :dob if column_exists? :users, :dob
  end
  def down
    add_column :users, :dob, :date unless column_exists? :users, :dob, :date
  end
end
