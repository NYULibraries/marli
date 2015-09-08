require 'test_helper'

class ApplicationDetailsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin)
  end
  
  test "should get index" do
    get :index
    assert_not_nil assigns(:application_details)
    assert_response :success
    assert_template :index
  end

  test "should get edit action" do
   get :edit, :id => FactoryGirl.create(:random_application_detail).id
   assert_not_nil assigns(:application_detail)
   assert_response :success
  end

  test "should update application detail" do
   put :update, :id => FactoryGirl.create(:random_application_detail).id, :application_detail => {:the_text => "updating this text"}

   assert assigns(:application_detail)
   assert_equal assigns(:application_detail).the_text, "updating this text"
   assert_redirected_to application_details_path
  end

  test "should throw update error on no text" do
   put :update, :id => FactoryGirl.create(:random_application_detail).id, :application_detail => {:the_text => ""}

   assert_template :edit
  end

  test "should toggle application status" do
    post :toggle_application_status
    assert File.exists? "#{Rails.root}/config/app_is_inactive.pid"
    sleep 1
    post :toggle_application_status
    assert (!File.exists? "#{Rails.root}/config/app_is_inactive.pid")
  end

end
