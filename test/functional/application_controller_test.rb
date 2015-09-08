require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin, username: "admin")
  end

  test "should test development functions" do
    @controller.current_user_dev
    assert assigns(:current_user)
  end

end
