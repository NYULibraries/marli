require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  setup do
    activate_authlogic
    # Pretend we've already checked PDS/Shibboleth for the session
    # and we have a session
    @request.cookies[:attempted_sso] = { value: "true" }
    @controller.session[:session_id] = "FakeSessionID"
    current_user = UserSession.create(users(:admin))
  end
  
  test "should get index" do
    get :index
    assert_not_nil assigns(:users)
    assert_response :success
    assert_template :index
  end
  
  test "should redirect non admin to root" do
    current_user = UserSession.create(users(:valid_patron))
    get :index
    assert_redirected_to root_url
  end
  
  test "should search index" do
    get :index, :q => "Smith"
    assert_not_nil assigns(:users)
    assert assigns(:users).count == 1
    assert_response :success
    assert_template :index
  end
  
  test "should get CSV from index" do
    # Gets affiliation text from cache or API call
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      get :index, :format => :csv
      assert_response :success
    end
  end
  
  test "should get new user form" do
    get :new
    
    assert assigns(:user)
    assert_response :success
    assert_template :new
  end
  
  test "should create new user" do
    assert_difference('User.count', 1) do
      post :create, :user => { :email => "realemail@realmail.edu", :username => "mynetid123" }
    end
  
    assert assigns(:user)
    assert_redirected_to user_path(assigns(:user))
  end
  
  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:nonadmin).to_param
    end

    assert_redirected_to users_url
  end
  
  test "should show user" do
    # Gets affiliation text from cache or API call
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      get :show, :id => users(:admin).to_param
      
      assert assigns(:user)
      assert_response :success
      assert_template :show
    end
  end
  
  test "show default affiliation text when no borrower status" do
    # Gets affiliation text from cache or API call
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      get :show, :id => users(:invalid_patron).to_param
      
      assert assigns(:user)
      assert_response :success
      assert_template :show
      assert_select "dd", {:count=>1, :text=>"&nbsp;NYU PhD Student"},
            "Wrong affiliation text or more than one element containing it"
    end
  end
  
  test "should update user as exception" do
    put :update, :id => users(:admin).to_param, :user => {:marli_exception => 1, :marli_admin => 1}
    
    assert assigns(:user)
    assert assigns(:user).user_attributes[:marli_exception]
    assert_equal flash[:notice], "Updated user"
    assert_redirected_to user_path(users(:admin))
  end
  
  test "should update user as admin" do
    put :update, :id => users(:patron_exception).to_param, :user => {:marli_admin => 1, :marli_exception => 1}
    
    assert assigns(:user)
    assert assigns(:user).user_attributes[:marli_admin]
    assert_equal flash[:notice], "Updated user"
    assert_redirected_to user_path(users(:patron_exception))
  end
  
  test "should reset an individual submission" do
    assert users(:real_user).submitted_request
    
    post :reset_submissions, :id => users(:real_user)
    
    users(:real_user).reload
    assert_nil users(:real_user).submitted_request
    assert_equal flash[:success], "Reset successful"
    assert_not_empty User.where(:submitted_request => true)
    assert_redirected_to users_url
  end
  
  test "should reset all submissions" do
    assert users(:real_user).submitted_request
    
    post :reset_submissions
    
    assert_equal flash[:success], "Reset successful"
    assert_empty User.where(:submitted_request => true)
    assert_redirected_to users_url
  end
  
  test "should delete all patrons" do
    post :clear_patron_data
    
    assert_equal flash[:success], "Deleted all non-admin patron data"
    assert_equal User.count, 1
    assert_redirected_to users_url
  end
  
  # With non-admin user
  test "get new registration form" do
    current_user = UserSession.create(users(:valid_patron))    
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      get :new_registration
        
      assert assigns(:user), "User instance var not set,"
      assert_response :success
      assert_template :new_registration
    end
  end
  
  test "submit registration successfully" do
    current_user = UserSession.create(users(:valid_patron))
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      post :create_registration, :user => {:dob => "1986-01-01", :barcode => "", :user_attributes => {:school => "NYU", :department => "", :marli_renewal => "0"} }

      assert assigns(:user), "User instance var not set,"
      assert assigns(:user).submitted_request
      assert_redirected_to confirmation_url
    end
  end
  
  test "submit registration with error on no school" do
    current_user = UserSession.create(users(:valid_patron))
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      post :create_registration, :user => {:dob => "1986-01-01", :barcode => "", :user_attributes => {:school => "", :department => "", :marli_renewal => "0"} }
      
      assert assigns(:user), "User instance var not set,"
      assert(!assigns(:user).submitted_request)
      assert_not_empty assigns(:user).errors
      assert_equal assigns(:user).errors.first.last, "School cannot be blank."
      assert_template :new_registration
    end
  end
  
  test "submit registration with error on no DOB" do
    current_user = UserSession.create(users(:valid_patron))
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      post :create_registration, :user => {:dob => "", :barcode => "", :user_attributes => {:school => "NYU", :department => "", :marli_renewal => "0"} }
      
      assert assigns(:user), "User instance var not set,"
      assert(!assigns(:user).submitted_request)
      assert_not_empty assigns(:user).errors
      assert_equal assigns(:user).errors.first.last, "Date of birth cannot be blank."
      assert_template :new_registration
    end
  end
  
  test "should render invalid patron page" do
    current_user = UserSession.create(users(:invalid_patron))
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      get :new_registration
      
      assert_template 'user_sessions/unauthorized_patron'
    end
  end

end