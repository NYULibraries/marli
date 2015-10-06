class AddInstitutionCodeToUsers < ActiveRecord::Migration
  def up
    add_column :users, :institution_code, :string
  end
  def down
    remove_column :users, :institution_code
  end
end
