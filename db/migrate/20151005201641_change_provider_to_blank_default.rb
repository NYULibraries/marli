class ChangeProviderToBlankDefault < ActiveRecord::Migration
  def up
    change_column :users, :provider, :string, null: false, default: ""
  end
  def down
    change_column :users, :provider, :string, null: true
  end
end
