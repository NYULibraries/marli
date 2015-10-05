class PopulateAlephIdFromUserAttributes < ActiveRecord::Migration
  def up
    say_with_time "Migrating Aleph ID." do
      User.all.each do |user|
        User.class_eval { serialize :user_attributes }
        unless user.user_attributes.blank?
          user.update_attribute :aleph_id, user.user_attributes[:nyuidn] unless user.user_attributes.nil?
        end
      end
    end
  end

  def down
  end
end
