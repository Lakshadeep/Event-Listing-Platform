require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  include Devise::TestHelpers                          
  include Warden::Test::Helpers                        
  Warden.test_mode!

  test "requires admin rights" do
    sign_in users(:sanoop)

    get :search_admin     
    assert_response 302

    post :search_results_admin, :search_key => "user", :search_type => "text"     
    assert_response 302

    get :user_admin, :user_id => 1    
    assert_response 302

    get :block_user, :user_id => 1    
    assert_response 302

    get :unblock_user, :user_id => 1    
    assert_response 302

    get :non_confirmed_events    
    assert_response 302

    get :confirm_event, :event_id => 1    
    assert_response 302

    get :delete_event, :event_id => 1    
    assert_response 302

  end


  test "admin_search" do
    sign_in users(:lakshadeep)
    post :search_results_admin, :search_key => 'India',:search_type => 'text'   
    assert_response :success
  end

  test "block and unblock user" do
    sign_in users(:lakshadeep)
    get :block_user, :user_id => users(:pradosh).id    
    assert_response :success

    get :unblock_user, :user_id => users(:pradosh).id    
    assert_response :success
  end

  test "confirm and delete event" do
    sign_in users(:lakshadeep)
    e = events(:event1)
    e.creator_id = users(:pradosh).id
    e.save

    get :confirm_event, :event_id => events(:event1).id  
    assert_response :success

    get :delete_event, :event_id => events(:event1).id   
    assert_response :success

  end

end
