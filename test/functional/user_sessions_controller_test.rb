require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  setup do
    activate_authlogic
    # Pretend we've already checked PDS/Shibboleth for the session
    # and we have a session
    @request.cookies[:attempted_sso] = { value: "true" }
    @controller.session[:session_id] = "FakeSessionID"
    current_user = UserSession.create(users(:nonadmin))
  end
  
  test "should validate and redirect to root" do
    get :validate
    
    assert_redirected_to root_url
  end

end