class Attendee < ActiveRecord::Base
  attr_accessible  :status, :invitor
  belongs_to :event
  belongs_to :user

  def self.send_invitations(invitor,receiver,event)
    if event.is_approved
      Notifier.delay.invited_for_event_email(receiver,event) 
      event.users << receiver
      x = Attendee.where(:user_id => receiver.id).where(:event_id => event.id).first
      x.status = "invitation_sent"
      x.invitor = invitor.id
      return x.save 
    else
      event.users << receiver
      x = Attendee.where(:user_id => receiver.id).where(:event_id => event.id).first
      x.invitor = invitor.id
      return x.save   
    end
  end

  def self.accept_invitation(user,event)
    transaction do 
      temp = Attendee.where(:user_id => user.id).where(:event_id => event.id).first
      temp.status = "confirmed"
      temp.save
      event.count_confirmed_people = event.count_confirmed_people.to_i + 1
      return event.save
    end
  end

  def self.reject_invitation(user,event)
    temp =Attendee.where(:user_id => user.id).where(:event_id => event.id).first
    temp.status = "rejected"
    return temp.save
  end

  def self.maybe_invitation(user,event)
    temp = Attendee.where(:user_id => user.id).where(:event_id => event.id).first
    temp.status = "maybe"
    return temp.save
  end

  def self.get_event_status_count(event,status)   #status = ['confirmed','maybe','rejected']          
    return Attendee.where(:event_id => event.id).where(:status => status).count
  end

  def self.get_event_status_list(event,status)          #status = ['confirmed','maybe','rejected']   
    attendees_list =  Attendee.where(:event_id => event.id).where(:status => status)
    results = attendees_list.collect do |x|
       User.find(x.user_id)
    end
    return results
  end

  def self.attend_event(user,event)
    transaction do 
      x = event.users << user
      attendees = Attendee.where(:event_id => event.id).where(:user_id => user.id).first
      attendees.status =  "confirmed"
      attendees.save
      event.count_confirmed_people = event.count_confirmed_people.to_i + 1
      return event.save
    end  
  end

end
