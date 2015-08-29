require 'test_helper'

class FriendTest < ActiveSupport::TestCase
  setup do
    @sender = users(:lakshadeep)
    @receiver = users(:sanoop)
    @receiver2 =  users(:pradosh)
  end

  test "friend_request" do
    #check basic friend resquest and accept working
  
    Friend.send_friend_request(@sender,@receiver)
    mail = ActionMailer::Base.deliveries.last
    assert_equal @receiver.email, mail['to'].to_s

    Friend.accept_friend_request(@sender,@receiver)

    receiver_friends = Friend.get_friends_list(@receiver)
    assert_equal(@sender.id,receiver_friends[0])

    #test if sender try to send friend request again after receiver has rejected it before
   
    Friend.send_friend_request(@sender,@receiver2)
    mail = ActionMailer::Base.deliveries.last
    assert_equal @receiver2.email, mail['to'].to_s

    Friend.reject_friend_request(@sender,@receiver2)

    assert_equal(false, Friend.send_friend_request(@sender,@receiver2)) 

  end  
end
