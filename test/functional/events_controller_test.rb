require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  include Devise::TestHelpers                          
  include Warden::Test::Helpers                        
  Warden.test_mode! 

  test "requires user login" do
       

    post :create, :title => "test_event",:latitude => 12.03,:longitude => 73.04,:address => "Goa",:cost => 100,:starttime =>  Time.zone.parse('2015-08-21 12:00'),:endtime =>  Time.zone.parse('2015-08-25 12:00'), :seats => 120,:creator_id => users(:sanoop).id,:category=>[]
    assert_response 302

    get :user_created_events              
    assert_response 302

    get :'event_user',:event_id => 1 
    assert_response 302

    image = fixture_file_upload 'coldplay.jpg'
    post :set_photo, :event_id => events(:event1).id, :photo => image
    assert_response 302

    get :'event_console',:event_id => 1 
    assert_response 302

    get :'attend_event',:event_id => 1 
    assert_response 302

    get :'invite_search',:event_id => 1 
    assert_response 302

    get :'invite_search_results',:event_id => 1 
    assert_response 302

    get :'accept_invitation',:event_id => 1 
    assert_response 302

    get :'send_email_invitation',:event_id => 1 
    assert_response 302

    get :'invite_via_email',:event_id => 1 
    assert_response 302

  end



 

  

  test "event_creation success and failure" do
    #tests successful creation of event
    sign_in users(:lakshadeep)
    post :create, :title => "test_event",:latitude => 12.03,:longitude => 73.04,:address => "Goa",:cost => 100,:starttime =>  Time.zone.parse('2015-08-21 12:00'),:endtime =>  Time.zone.parse('2015-08-25 12:00'), :seats => 120,:creator_id => session[:user_id],:category=>[]

    assert_equal "You have successfully created an event",flash[:notice]

    #test event creation failure
    post :create, :title => "test_event",:latitude => 12.03,:longitude => 73.04,:address => "Goa",:starttime =>  Time.zone.parse('2015-08-21 12:00'),:endtime =>  Time.zone.parse('2015-08-25 12:00'), :seats => 120,:creator_id => session[:user_id],:category=>[]
    assert_redirected_to(:action=>"new", :controller=>"events")
    assert_not_equal "You have successfully created an event",flash[:notice]
  end

  test "user_created_events" do
    sign_in users(:lakshadeep)
    get :user_created_events                   
    assert_response :success
  end

  test "event_user" do
    sign_in users(:lakshadeep)
    assert_raise( ActiveRecord::RecordNotFound) {get :'event_user',:event_id => 1 }
  end


  test "set_event_photo" do
    #test uploading of event photo
    sign_in users(:lakshadeep)
    image = fixture_file_upload 'coldplay.jpg'
    post :set_photo, :event_id => events(:event1).id, :photo => image
    assert_equal "Photo added successfully",flash[:notice] 
  end

  test "attend_event" do
    sign_in users(:lakshadeep)
    get :attend_event, :event_id => events(:event1).id, :user_id => users(:lakshadeep).id
    assert_response :success
  end

  test "invite_user" do
    sign_in users(:lakshadeep)
    event = events(:event1)
    user = users(:lakshadeep)
    get :invite_user, :event_id => events(:event1).id, :user_id => users(:pradosh).id
    assert_response :success
  end

  test "send_invitation" do
    sign_in users(:lakshadeep)
    get :invite, :event_id => events(:event1).id, :user_id => users(:pradosh).id
    assert_response :success

    sign_out users(:lakshadeep)

    sign_in users(:pradosh)
    get :accept_invitation, :event_id => events(:event1).id
    assert_response :success
  end


  

  test "send_email_invitation" do
    email = 'lakshadeep.naik@gmail.com'
    sign_in users(:pradosh)
    user1 =  User.create_user(name: 'test1',email: 'test@mail.com',password: '12345678',password_confirmation: '12345678',is_admin: false)

    event_hash1 = {
      "title" => "event1",
      "address" => "Panaji Goa",
      "price" => 120,
      "start_time" => Time.zone.parse('2015-09-28 21:00'),
      "end_time" => Time.zone.parse('2015-09-28 23:00'),
      "total_seats" => 100,
      "is_approved" => false,
      "creator_id" => user1[0].id
    }
    event1 = Event.create_event(event_hash1)
 
    event1[0].confirm_event()
    get :send_email_invitation, :event_id => event1[0].id, :invitor_id => users(:pradosh).id, :email => email
    assert_redirected_to(:action=>"event_user", :controller=>"events",:event_id => event1[0].id)

    get :invite_via_email, :event_id => event1[0].id, :invitor_id => user1[0].id
    assert_redirected_to(:action=>"pending_invitations", :controller=>"users")
  end
end
