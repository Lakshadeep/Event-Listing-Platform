require 'test_helper'

class PublicsControllerTest < ActionController::TestCase
  include Devise::TestHelpers                          
  include Warden::Test::Helpers                        
  Warden.test_mode! 

  test "no log in required" do
  	get :index              
    assert_response 200

    post :search, :search_key => "event", :search_type => "text"              
    assert_response 200

    post :search, :search_key => Time.zone.parse('2015-08-28'), :search_type => "date"              
    assert_response 200

    post :search, :search_key => "12.04,73.05", :search_type => "location"              
    assert_response 200

    post :search, :category => ["1"], :search_type => "tags"              
    assert_response 200

    get :attendee_list, :event_id => events(:event1).id, :status_code => 1             
    assert_response 200
  end


  test "attendee_list response" do
    get :attendee_list, :event_id => events(:event1).id , :status_code => 1                   
    assert_response :success
  end

  test "event_info_redirect" do
    sign_in users(:lakshadeep)
    get :event_info, :event_id => events(:event1).id
    assert_redirected_to(:action=>"event_user", :controller=>"events",:event_id=> events(:event1).id)

    sign_out users(:lakshadeep)
    get :event_info, :event_id => events(:event1).id
    assert_redirected_to(:action=>"event_public", :controller=>"publics",:event_id=> events(:event1).id)
  end

  test "event_public" do
    assert_raise( ActiveRecord::RecordNotFound) {get :'event_public',:event_id => 1 }
  end


end
