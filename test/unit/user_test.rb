require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "user search" do
    user = FactoryGirl.create(:user)
    assert_not_empty User.search(user.firstname)
    assert_not_empty User.search(user.lastname)
    assert_empty User.search(Faker::Internet.free_email)
  end

end
