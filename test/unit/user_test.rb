require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user_creation" do
  	#test if user was successfully saved in database
  	user1 =  User.create_user(name: 'test1',email: 'test@mail.com',password: '12345678',password_confirmation: '12345678',is_admin: false)

  	user1_check = User.last
  	assert_equal(user1[0],user1_check)

  	#tests email validation
  	user2 = User.create_user(name: 'test1',email: 'test',password: '12345678',password_confirmation: '12345678',is_admin: false)

  	assert_nil user2[0]

  	#tests password validation
  	user3 = User.create_user(name: 'test1',email: 'test@mail.com',password: '123478',password_confirmation: '12345678',is_admin: false)

  	assert_nil user3[0]
  end

 
  test "user_created_events" do
  	#test user_created_events_method
  	user1 =  users(:lakshadeep)

  	event_hash1 = {
  		"title" => "event1",
  		"address" => "Panaji",
  		"price" => 120,
  		"start_time" => Time.zone.parse('2015-08-28 21:00'),
  		"end_time" => Time.zone.parse('2015-08-28 23:00'),
  		"total_seats" => 100,
  		"creator_id" => user1.id,
      "is_approved" => true
	  }
    event1 = Event.create_event(event_hash1)
	  assert_equal(event1[0],user1.get_user_created_events()[0])
  end

  test "user_invitation_stats" do
  	#tests get_user_invitation_stats method
  	sender =  users(:lakshadeep)
  	receiver =  users(:sanoop)
  	event1 = events(:event1)
	  Attendee.send_invitations(sender,receiver,event1)
  	assert_equal(1 , sender.get_user_invitation_stats(event1)[0])
  end

  test "user_block" do
   	#test user deletion
  	user1 =  users(:pradosh)
   	user1_id = user1.id
  	user1.block_user()
   	assert_equal true, user1.is_blocked 

    mail = ActionMailer::Base.deliveries.last
    assert_equal user1.email, mail['to'].to_s
  end

  test "user_search" do
    text_search_test_user = users(:lakshadeep)
    text_search = User.search(search_key: "lakshadeep",text: true)
    assert_equal(text_search_test_user,text_search[0])

    interest_search_test_user = users(:sanoop)
    t1 = Tag.create({tag: "Music"})
    interest_search_test_user.tags << t1 
    interest_search = User.search(tag: true,tags_array: [t1] )
    assert_equal(interest_search_test_user,interest_search[0])

    text_interest_search_test_user = users(:pradosh)
    t1 = Tag.create({tag: "Music"})
    text_interest_search_test_user.tags << t1 
    text_interest_search = User.search(tag: true,tags_array: [t1],text: true,search_key: "pradosh" )
    assert_equal(text_interest_search_test_user,text_interest_search[0])
    
  end


  test "search_friends_success" do
    @sender = users(:lakshadeep)
    @receiver = users(:sanoop)

    Friend.send_friend_request(@sender,@receiver)
    Friend.accept_friend_request(@sender,@receiver)

    t1 = Tag.create({tag: "Music"})
    @sender.tags << t1
    @receiver.tags << t1 

    result = @sender.search_friends("sanoop")
    assert_equal(@receiver,result[0])
  end

  test "search_friends_failure" do
    @sender = users(:lakshadeep)
    @receiver = users(:sanoop)

    t1 = Tag.create({tag: "Music"})
    @sender.tags << t1
    @receiver.tags << t1 

    result = @sender.search_friends("sanoop")
    assert_nil result[0]
  end

  test "test_get_event_user_list_success" do
    event = events(:event1)
    user = users(:lakshadeep)
    Attendee.attend_event(user,event)
    result = user.get_user_event_list("confirmed")
    assert_equal(event,result[0][0])
  end

  test "test_get_event_user_list_failure" do
    event = events(:event1)
    user = users(:lakshadeep)

    result = user.get_user_event_list("confirmed")
    assert_nil result[0]
  end


end
