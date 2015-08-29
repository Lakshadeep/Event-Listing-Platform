require 'test_helper'


class UsersControllerTest < ActionController::TestCase

  include Devise::TestHelpers                          
  include Warden::Test::Helpers                        
  Warden.test_mode!                                    


  test "requires user log in" do
    post :home, :lat => '15.798',:lng => '73.208'               
    assert_response 302

    get :'location'
    assert_response 302

    get :'search'
    assert_response 302

    get :'search_results',:search_key => "test event", :search_type => "text"
    assert_response 302

    get :'send_friend_request', :sender_id => 1, :receiver_id => 2
    assert_response 302

    get :'accept_friend_request', :sender_id => 1, :receiver_id => 2
    assert_response 302

    get :'reject_friend_request', :sender_id => 1, :receiver_id => 2
    assert_response 302

    get :'pending_friend_requests'
    assert_response 302

    get :'pending_invitations'
    assert_response 302

    get :'user_public', :user_id => 1
    assert_response 302

    get :'user_friends'
    assert_response 302

    get :'user_info', :user_id => 1
    assert_response 302

    get :'profile'
    assert_response 302

    get :'friends'
    assert_response 302

  end

  test "home" do
    sign_in users(:lakshadeep)   
    post :home, :lat => '15.798',:lng => '73.208'                   #requires login
    assert_response :success
  end

  test "user_search" do
    sign_in users(:sanoop)
    post :search_results, :search_key => 'India',:search_type => 'text'    
    assert_response :success
  end

  test "send_accept_friend_request" do
    sign_in users(:lakshadeep)
    get :'send_friend_request',:sender_id => users(:lakshadeep).id, :receiver_id => users(:pradosh).id
    assert_response :success
    get :'accept_friend_request',:sender_id => users(:lakshadeep).id, :receiver_id => users(:pradosh).id
    assert_response :success
    
    #user_info redirect test part 1
    get :user_info, :user_id => users(:pradosh).id
    assert_redirected_to(:action=>"user_friends", :controller=>"users",:user_id=> users(:pradosh).id)
  end

  test "user_info_redirect_part_2" do
    sign_in users(:sanoop)
    get :user_info, :user_id => users(:pradosh).id
    assert_redirected_to(:action=>"user_public", :controller=>"users",:user_id=> users(:pradosh).id)

  end

  
  


end
