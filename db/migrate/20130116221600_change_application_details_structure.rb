class ChangeApplicationDetailsStructure < ActiveRecord::Migration
  def up
    execute "truncate table application_details"
    remove_column :application_details, :config_option
    remove_column :application_details, :config_option_webtext
    remove_column :application_details, :config_value
    remove_column :application_details, :config_description
    remove_column :application_details, :config_active
    add_column :application_details, :purpose, :string
    add_column :application_details, :the_text, :text
    add_column :application_details, :description, :string
  end

  def down
    add_column :application_details, :config_option, :string
    add_column :application_details, :config_option_webtext, :text
    add_column :application_details, :config_value, :string
    add_column :application_details, :config_description, :text
    add_column :application_details, :config_active, :boolean
    remove_column :application_details, :purpose
    remove_column :application_details, :the_text
    remove_column :application_details, :description
  end
end