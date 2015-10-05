class PopulateAlephIdFromUserAttributes < ActiveRecord::Migration
  def up
    say_with_time "Migrating Aleph ID." do
      User.class_eval { serialize :user_attributes }
      User.all.each do |user|
        unless user.user_attributes.blank?
          user.update_attribute :aleph_id, user.user_attributes[:nyuidn]
        end
      end
    end
  end

  def down
  end
end
