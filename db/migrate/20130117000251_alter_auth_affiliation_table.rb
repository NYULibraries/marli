class AlterAuthAffiliationTable < ActiveRecord::Migration
  def up
    rename_table :auth_affiliations, :patron_statuses
    rename_column :patron_statuses, :affiliation_code, :code
    rename_column :patron_statuses, :affiliation_title, :web_text
  end

  def down
    rename_table :patron_statuses, :auth_affiliations
    rename_column :patron_statuses, :code, :affiliation_code
    rename_column :patron_statuses, :web_text, :affiliation_title
  end
end
