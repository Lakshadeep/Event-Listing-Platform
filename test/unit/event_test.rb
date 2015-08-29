require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @user1 =  User.create_user(name: 'test1',email: 'test@mail.com',password: '12345678',password_confirmation: '12345678',is_admin: false)
  end


  test "event_creation" do
  	#tests for correct entry in database
  	event_hash1 = {
  		"title" => "event1",
  		"address" => "Panaji Goa",
  		"price" => 120,
  		"start_time" => Time.zone.parse('2015-09-28 21:00'),
  		"end_time" => Time.zone.parse('2015-09-28 23:00'),
  		"total_seats" => 100,
  		"creator_id" => 1
	 }
  event1 = Event.create_event(event_hash1)
  event1_check = Event.last
  assert_equal(event1[0],event1_check)

  mail = ActionMailer::Base.deliveries.last
  
  assert_equal('lakshadeep@vacationlabs.com', mail['to'].to_s)

  #tests human readable address
  event_hash2 = {
  	"title" => "event2",
  	"address" => "Panaji?",
  	"price" => 120,
  	"start_time" => Time.zone.parse('2015-09-28 21:00'),
  	"end_time" => Time.zone.parse('2015-09-28 23:00'),
  	"total_seats" => 100,
  	"creator_id" => 1
	}
	event2 = Event.create_event(event_hash2)
  assert_nil event2[0]

  	#tests human readable address
  event_hash3 = {
  	"title" => "event3",
  	"address" => "Panaji.",
  	"price" => 120,
  	"start_time" => Time.zone.parse('2015-09-28 21:00'),
		"end_time" => Time.zone.parse('2015-09-28 23:00'),
  	"total_seats" => 100,
  	"creator_id" => 1
	}
  event3 = Event.create_event(event_hash3)
  assert_not_nil  event3[0]
  end

  test "confirm_event_test" do
  	#checks if event was successfully approved
  	event_hash1 = {
  		"title" => "event1",
  		"address" => "Panaji Goa",
  		"price" => 120,
  		"start_time" => Time.zone.parse('2015-09-28 21:00'),
  		"end_time" => Time.zone.parse('2015-09-28 23:00'),
  		"total_seats" => 100,
  		"is_approved" => true,
  		"creator_id" => @user1[0].id
	  }
  	event1 = Event.create_event(event_hash1)
 
  	event1[0].confirm_event()
  	assert_equal(true, event1[0].is_approved)

    mail = ActionMailer::Base.deliveries.last
    assert_equal(@user1[0].email, mail['to'].to_s)
  end

  

  test "event_delete" do
  	#test deletion of an event
  	event_hash1 = {
  		"title" => "event1",
  		"address" => "Panaji Goa",
  		"price" => 120,
  		"start_time" => Time.zone.parse('2015-09-28 21:00'),
  		"end_time" => Time.zone.parse('2015-09-28 23:00'),
  		"total_seats" => 100,
  		"is_approved" => false,
  		"creator_id" => @user1[0].id
	  }
    event1 = Event.create_event(event_hash1)

    event1_id = event1[0].id
    event1[0].delete_event()
    mail = ActionMailer::Base.deliveries.last
    assert_equal(@user1[0].email, mail['to'].to_s)
  end


  test 'event_lists' do
    #tests upcoming events
    upcoming_events = Event.get_upcoming_events(5)
    upcoming_test_event = events(:event1)
    assert_equal(upcoming_test_event,upcoming_events[0])

    #tests events in nearby locations
    near_location = Event.get_location_based_event_list(15.0,73.0,5)
    near_location_test_event = events(:event1)
    assert_equal(near_location_test_event,near_location[0])

    event_hash1 = {
      "title" => "event1",
      "address" => "Panaji Goa",
      "price" => 120,
      "start_time" => Time.zone.parse('2015-09-28 21:00'),
      "end_time" => Time.zone.parse('2015-09-28 23:00'),
      "total_seats" => 100,
      "is_approved" => true,
      "creator_id" => 1
    }
    #tests recently created events
    event1 = Event.create_event(event_hash1)
    recently_created_events = Event.get_recently_created_event_list(5)
    assert_equal(event1[0],recently_created_events[0])

    t1 = Tag.create({tag: "Music"})
    t1.users << @user1[0]

    t1.events << event1[0]

    user_interested_events = Event.get_similar_events(@user1[0].tags)
    assert_equal(event1[0],user_interested_events[0])

  end

  test 'search' do
    #test text search
    text_search_test_event = events(:event1)
    text_search = Event.search(search_key: "event 1",text: true)
    assert_equal(text_search_test_event,text_search[0])

    #test date search
    date_search_test_event = events(:event2)
    date_search = Event.search(date_key: Time.zone.parse('2015-08-28'),date: true)
    assert_equal(date_search_test_event,date_search[0])
    
    #test location search
    location_search_test_event = events(:event3)
    location_search = Event.search(user_lat: 25,user_lng: 83,location: true, radius: 50)
    assert_equal(location_search_test_event,location_search[0])

    #test tag based search
    tag_search_test_event = events(:event4)
    t1 = Tag.create({tag: "Music"})
    t1.events << tag_search_test_event

    tag_search = Event.search(tags: true, tags_array: [t1])
    assert_equal(tag_search_test_event,tag_search[0])

    #text and location based search
    text_location_search_test_event = events(:event3)
    text_location_search = Event.search(user_lat: 25,user_lng: 83,location: true, radius: 50, search_key: "event3",text: true )
    assert_equal(text_location_search_test_event,text_location_search[0])

    #text and date based search
    text_date_search_test_event = events(:event2)
    text_date_search = Event.search(date_key: Time.zone.parse('2015-08-28'),date: true, search_key: "event2",text: true )
    assert_equal(text_date_search_test_event,text_date_search[0])

    #tag and date based search
    tag_date_search_test_event = events(:event4)
    t1 = Tag.create({tag: "Sports"})
    t1.events << tag_date_search_test_event
    tag_date_search = Event.search(tags_array: [t1],tags: true, search_key: "event4",text: true )
    assert_equal(tag_date_search_test_event,tag_date_search[0])

  end

end
