class RemovePersistenceTokenFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :persistence_token
  end
  def down
    add_column :users, :persistence_token, :string
  end
end
