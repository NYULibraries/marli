class AddAffiliationTextToUsers < ActiveRecord::Migration
  def up
    add_column :users, :affiliation_text, :text
    say_with_time "Migrating affiliation text to users." do
      User.class_eval { serialize :user_attributes }
      User.all.each do |user|
        user.update_attribute :affiliation_text,  user.user_attributes[:affiliation_text] unless user.user_attributes.nil?
      end
    end
  end

  def down
    remove_column :users, :affiliation_text
  end
end
