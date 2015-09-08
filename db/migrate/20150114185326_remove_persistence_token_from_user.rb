class RemovePersistenceTokenFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :persistence_token
  end
end
