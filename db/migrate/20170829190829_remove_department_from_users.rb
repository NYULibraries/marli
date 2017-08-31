class RemoveDepartmentFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :department if column_exists? :users, :department
  end
  def down
    add_column :users, :department, :string unless column_exists? :users, :department, :string
  end
end
