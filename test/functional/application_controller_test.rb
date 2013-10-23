require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  
  setup do
    activate_authlogic
    # Pretend we've already checked PDS/Shibboleth for the session
    # and we have a session
    @request.cookies[:attempted_sso] = { value: "true" }
    @controller.session[:session_id] = "FakeSessionID"
    current_user = UserSession.create(users(:admin))
  end
  
  test "should test development functions" do
    controller.current_user_dev
    assert assigns(:current_user)
  end
  
end