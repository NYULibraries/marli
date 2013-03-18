require 'test_helper'

class UserSessionTest < ActiveSupport::TestCase

  setup :activate_authlogic

  test "get additional attributes address" do
    VCR.use_cassette('patron additional attributes') do
      # Use a real user from PDS to verify address
      user_session = UserSession.create(users(:real_user))
      set_dummy_pds_user(user_session)
      addr_info = user_session.additional_attributes
      # Make sure all parts of address are set correctly
      assert_not_nil(addr_info)
      assert_not_nil(addr_info[:address])
      assert_equal(addr_info[:address][:street_address], "100 Testing Lane")
      assert_equal(addr_info[:address][:city], "Testing Town")
      assert_equal(addr_info[:address][:state], "NY")
      assert_equal(addr_info[:address][:postal_code], "10012")
    end
  end

end