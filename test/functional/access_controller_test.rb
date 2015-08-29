require 'test_helper'

class AccessControllerTest < ActionController::TestCase
  test "no user login required" do
    get :login
    assert_response :success

    get :signup
    assert_response :success

  end

  test "direct_to_login" do
  	get :login
    assert_response :success
  end

  test "login_failure" do
    post :attempt_login, :email => 'lakshadeep.naik@gmail.com', :password => '1234'
    assert_redirected_to(:controller => "access", :action => "login")
  end

  test "signup, login success and logout" do
    post :attempt_signup, :name => 'lakshadeep',:email => 'lakshadeep.naik3@gmail.com',:pwd => '1234',:pwd_confirm => '1234',:category=>[]
    assert_redirected_to(:controller => "access", :action => "login")
    assert_equal "You have successfully signed up",flash[:notice]

    post :attempt_login, :email => 'lakshadeep.naik3@gmail.com', :password => '1234'
    assert_redirected_to(:controller => "users", :action => "location")
    assert_equal "You have successfully logged in",flash[:notice]

    get :logout
    assert_redirected_to(:controller => "access", :action => "login")
    assert_equal "Successfully logged out",flash[:notice]

  end

end
