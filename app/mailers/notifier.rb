class Notifier < ActionMailer::Base
  default from: "lakshadeep.naik2@gmail.com"

  def send_event_accepted_email(user,event)
    @user = user
    @event = event
    mail( :to => @user.email,
    :subject => 'Your event '+event.title+ ' has been accepted' )
  end

  def send_event_rejected_email(user,event)
    @user = user
    @event = event
    mail( :to => @user.email,
    :subject => 'Your event '+event.title+ ' has been rejected' )
  end

  def send_user_blocked_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Your account on EventApp has been blocked by admin' )
  end

  def send_user_unblocked_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Your account on EventApp has been unblocked by admin' )
  end

  def new_event_created_email(event,admin)
    @event = event
    mail( :to => admin.email,
    :subject => 'New event '+event.title+ ' has been created ')
  end

  def friend_request_sent_email(sender,receiver)
    @sender = sender
    @receiver = receiver
    mail( :to => receiver.email,
    :subject => sender.name + ' wants to be friend with you on EventApp')
  end

  def invited_for_event_email(sender,receiver)
    @sender = sender
    @receiver = receiver
    mail( :to => receiver.email,
    :subject => sender.name + ' wants to be friend with you on EventApp')
  end

  def invited_for_event_email(user,event)
    @event = event
    @user = user
    mail( :to => user.email,
    :subject => 'You have been invited for event '+ event.title+ ' on EventApp')
  end

  def send_email_invitation(event,invitor,email)
    @event = event
    @invitor = invitor
    mail( :to => email,
    :subject => 'You have been invited for event '+ event.title+ ' on EventApp')
  end
end
