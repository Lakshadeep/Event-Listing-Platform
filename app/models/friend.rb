class Friend < ActiveRecord::Base
  attr_accessible :receiver_id, :status
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  def self.send_friend_request(sender,receiver)
    begin
      sender.receivers << receiver
      Notifier.delay.friend_request_sent_email(sender,receiver)
      return true
    rescue ActiveRecord::RecordNotUnique  => invalid
      return false
    end
  end

  def self.accept_friend_request(sender,receiver)    
    friend_array = sender.friends.where("receiver_id = ? and status = ?",receiver.id,'pending').first
    friend_array.status = 'accepted'
    friend_array.save
    if friend_array.save
      return true
    else
      return false
    end
  end

  def self.reject_friend_request(sender,receiver)
    friend_array = sender.friends.where("receiver_id = ? and status = ?",receiver.id,'pending').first
    friend_array.status = 'rejected'
    friend_array.save
    if friend_array.save
      return true
    else
      return false
    end
  end

  def self.get_pending_friend_requests(user)
    pending_requests = Friend.where("receiver_id = ? and status = ?",user.id,'pending')
    return pending_requests
  end

  def self.get_friends_list(user)
    x = Friend.where("(sender_id = ? or receiver_id = ?) and status = ?",user.id,user.id,'accepted')
    result = x.collect do |x|
      if x.sender_id == user.id
        x.receiver_id
      elsif x.receiver_id == user.id
        x.sender_id
      end
    end
    return result  
  end

  def self.get_friend_status(sender,receiver)
    x = Friend.where("sender_id = ? and receiver_id = ?",sender.id,receiver.id)
    return x.length == 0 ? "not_friend" : x[0].status
  end

  
end
