require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin)
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:users)
    assert_response :success
    assert_template :index
  end

  test "should redirect non admin to root" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in FactoryGirl.create(:user)
    get :index
    assert_redirected_to root_url
  end

  test "should search index" do
    get :index, :q => User.first.lastname
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
    user = FactoryGirl.create(:user)
    assert_difference('User.count', -1) do
      delete :destroy, :id => user.to_param
    end

    assert_redirected_to users_url
  end

  test "should show user" do
    # Gets affiliation text from cache or API call
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      get :show, :id => FactoryGirl.create(:admin).to_param

      assert assigns(:user)
      assert_response :success
      assert_template :show
    end
  end

  test "show default affiliation text when no borrower status" do
    # Gets affiliation text from cache or API call
    FactoryGirl.create(:random_application_detail, purpose: "default_patron_type", the_text: "NYU PhD Student")
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      get :show, :id => FactoryGirl.create(:user).to_param

      assert assigns(:user)
      assert_response :success
      assert_template :show
      assert_select "dd", {:count=>1, :text=>"&nbsp;NYU PhD Student"},
            "Wrong affiliation text or more than one element containing it"
    end
  end

  test "should update user as exception" do
    admin_user = FactoryGirl.create(:admin)
    put :update, :id => admin_user.to_param, :user => {:admin => 1, :override_access => 1}

    assert assigns(:user)
    assert assigns(:user).override_access
    assert_equal flash[:notice], "Updated user"
    assert_redirected_to user_path(admin_user)
  end

  test "should update user as admin" do
    user_with_override_access = FactoryGirl.create(:override_access)
    put :update, :id => user_with_override_access.to_param, :user => {:admin => 1, :override_access => 1}

    assert assigns(:user)
    assert assigns(:user).admin
    assert_equal flash[:notice], "Updated user"
    assert_redirected_to user_path(user_with_override_access)
  end

  test "should reset an individual submission" do
    user_with_temporary_submitted_request = FactoryGirl.create(:user)
    user_with_temporary_submitted_request.submitted_request = true
    user_with_temporary_submitted_request.save!
    assert user_with_temporary_submitted_request.submitted_request

    user_with_submitted_request = FactoryGirl.create(:user)
    user_with_submitted_request.submitted_request = true
    user_with_submitted_request.save!
    assert user_with_submitted_request.submitted_request

    post :reset_submissions, :id => user_with_temporary_submitted_request

    user_with_temporary_submitted_request.reload
    user_with_submitted_request.reload

    assert_nil user_with_temporary_submitted_request.submitted_request
    assert_equal flash[:success], "Reset successful"
    assert_not_empty User.where(:submitted_request => true)
    assert_redirected_to users_url
  end

  test "should reset all submissions" do
    user_with_submitted_request = FactoryGirl.create(:user)
    user_with_submitted_request.submitted_request = true

    assert user_with_submitted_request.submitted_request

    post :reset_submissions
    assert_equal flash[:success], "Reset successful"
    assert_empty User.where(:submitted_request => true)
    assert_redirected_to users_url
  end

  test "should delete all patrons" do
    post :clear_patron_data

    assert_equal flash[:success], "Deleted all non-admin patron data"
    assert_equal User.count, User.count(:admin)
    assert_redirected_to users_url
  end

  # With non-admin user
  test "get new registration form" do
    @request.env["devise.mapping"] = Devise.mappings[:valid_patron]
    sign_in FactoryGirl.create(:valid_patron)
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      get :new_registration

      assert assigns(:user), "User instance var not set,"
      assert_response :success
      assert_template :new_registration
    end
  end

  test "submit registration successfully" do
    @request.env["devise.mapping"] = Devise.mappings[:valid_patron]
    sign_in FactoryGirl.create(:valid_patron)
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      post :create_registration, :user => {:dob => "1986-01-01", :barcode => "", :school => "NYU", :department => "", :marli_renewal => "0" }

      assert assigns(:user), "User instance var not set,"
      assert assigns(:user).submitted_request
      assert_redirected_to confirmation_url
    end
  end

  test "submit registration with error on no school" do
    @request.env["devise.mapping"] = Devise.mappings[:valid_patron]
    sign_in FactoryGirl.create(:valid_patron)
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      post :create_registration, :user => {:dob => "1986-01-01", :barcode => "", :school => "", :department => "", :marli_renewal => "0" }

      assert assigns(:user), "User instance var not set,"
      assert(!assigns(:user).submitted_request)
      assert_not_empty assigns(:user).errors
      assert_equal assigns(:user).errors.first.last, "School cannot be blank."
      assert_template :new_registration
    end
  end

  test "submit registration with error on no DOB" do
    @request.env["devise.mapping"] = Devise.mappings[:valid_patron]
    sign_in FactoryGirl.create(:valid_patron)
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      post :create_registration, :user => {:dob => "", :barcode => "", :school => "NYU", :department => "", :marli_renewal => "0" }

      assert assigns(:user), "User instance var not set,"
      assert(!assigns(:user).submitted_request)
      assert_not_empty assigns(:user).errors
      assert_equal assigns(:user).errors.first.last, "Date of birth cannot be blank."
      assert_template :new_registration
    end
  end

  test "should render invalid patron page" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in FactoryGirl.create(:user)
    VCR.use_cassette('get privileges from api', :match_requests_on => [:path]) do
      get :new_registration

      assert_template 'errors/unauthorized_patron'
    end
  end

end
