class RemoveSchoolFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :school if column_exists? :users, :school
  end
  def down
    add_column :users, :school, :string unless column_exists? :users, :school, :string
  end
end
