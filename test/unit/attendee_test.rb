require 'test_helper'

class AttendeeTest < ActiveSupport::TestCase

  setup do
    # do stuff once
    @user1 =  users(:lakshadeep)
    @user2 =  users(:pradosh)
  end

  test "send_accept_invitation" do
    #tests sending invitation to other users
    
    event1 = events(:event1)
    Attendee.send_invitations(@user1,@user2,event1)

    mail = ActionMailer::Base.deliveries.last
    assert_equal @user2.email, mail['to'].to_s

    Attendee.accept_invitation(@user2,event1)
    attendee = Attendee.last
    assert_equal "confirmed",attendee.status
    
    assert_equal(1,Attendee.get_event_status_count(event1,"confirmed"))

    assert_equal(@user2,Attendee.get_event_status_list(event1,"confirmed")[0])

    assert_equal(0,Attendee.get_event_status_count(event1,"maybe"))
  
    assert_equal(0,Attendee.get_event_status_count(event1,"rejected"))
  end

  test "send_reject_invitation" do
    event2 = events(:event2)
    Attendee.send_invitations(@user1,@user2,event2)
    mail = ActionMailer::Base.deliveries.last
    assert_equal @user2.email, mail['to'].to_s

    Attendee.reject_invitation(@user2,event2)
    attendee = Attendee.last
    assert_equal "rejected",attendee.status
    
    assert_equal(1,Attendee.get_event_status_count(event2,"rejected"))

    assert_equal(@user2,Attendee.get_event_status_list(event2,"rejected")[0])

    assert_equal(0,Attendee.get_event_status_count(event2,"maybe"))
  
    assert_equal(0,Attendee.get_event_status_count(event2,"confirmed"))

  end


  test "send_maybe_invitation" do
    event3 = events(:event3)
    Attendee.send_invitations(@user1,@user2,event3)
    mail = ActionMailer::Base.deliveries.last
    assert_equal @user2.email, mail['to'].to_s

    Attendee.maybe_invitation(@user2,event3)
    attendee = Attendee.last
    assert_equal "maybe",attendee.status
    
    assert_equal(1,Attendee.get_event_status_count(event3,"maybe"))

    assert_equal(@user2,Attendee.get_event_status_list(event3,"maybe")[0])

    assert_equal(0,Attendee.get_event_status_count(event3,"rejected"))
  
    assert_equal(0,Attendee.get_event_status_count(event3,"confirmed"))

  end
end
