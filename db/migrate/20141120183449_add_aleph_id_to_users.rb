class AddAlephIdToUsers < ActiveRecord::Migration
  def up
    add_column :users, :aleph_id, :string
  end
  def down
    remove_column :users, :aleph_id
  end
end
