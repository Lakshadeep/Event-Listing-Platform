class EventsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # authorize_resource :class => false 
  layout :get_layout

  # rescue_from CanCan::AccessDenied do |exception|
  #       render :json => {
  #         :flash => {
  #           :errors => [exception.message]
  #         }
  #       }, :status => 401
  #     end


  def new               #create event form
  end

  def create             #called on submission of new event form
    event_hash = {
      "title" => params[:title],
      "latitude" => params[:latitude],
      "longitude" => params[:longitude],
      "address" => params[:address],
      "price" => params[:cost],
      "start_time" => params[:starttime],
      "end_time" => params[:endtime],
      "total_seats" => params[:seats],
      "creator_id" => current_user.id
    }
    event = Event.create_event(event_hash)
    if event[0].nil?
      flash[:notice] = event[1]
      redirect_to(:action=>"new", :controller=>"events")
    else
      category = params[:category]
        if category.nil? != true  
        category.each do |x|
          t = Tag.find(x.to_i)
          t.events << Event.find(event[0].id)
        end
      end
      flash[:notice] = 'You have successfully created an event'
      redirect_to(:action=>"event_console", :controller=>"events",:event_id => event[0].id)
    end  
  end

  def event_console         #displayed on creating a new event and is also availbel under 
    @event = Event.find(params[:event_id])
    if @event.creator_id != current_user.id
      flash[:alert] = 'You are not the owner of that event'
      redirect_to(:action=>"index", :controller=>"publics")
    else  
      @event_pics = @event.photos
      @confirmed_count = Attendee.get_event_status_count(@event,"confirmed")
      @maybe_count = Attendee.get_event_status_count(@event,"maybe")
      @rejected_count = Attendee.get_event_status_count(@event,"rejected")
    end
  end                       #options->View your events  once event is confirmed by admin

  def set_photo             #adds new photo to events, availabel in event console
    event = Event.find(params[:event_id])
    

    event_pic = Photo.create({event_pic: params[:file]})

    if event.photos.empty?
      event.first_pic = event_pic.event_pic
      event.save
    end
    event.photos << event_pic
    
    flash[:notice] = 'Photo added successfully'
    redirect_to(:action=>"event_console", :controller=>"events",:event_id=> params[:event_id].to_i)
  end
 
  def user_created_events       #displays the events created by the user
    user = User.find(current_user.id)
    @user_events = user.get_user_events()
  end

  def event_user            #event info page availabel for logged in users
    event_id = params[:event_id]
    @event = Event.find(params[:event_id])
    @event_pics = @event.photos
    creator = User.find(@event.creator_id)
    @event_user_status = @event.event_user_status(current_user)

    @confirmed_count = Attendee.get_event_status_count(@event,"confirmed")
    @maybe_count = Attendee.get_event_status_count(@event,"maybe")
    @rejected_count = Attendee.get_event_status_count(@event,"rejected")
    @nearby_events = Event.get_location_based_event_list(@event.latitude,@event.longitude,3).page params[:nearby]
    @other_events_by_user = creator.get_user_created_events().page params[:user_created]
    @similar_events = Kaminari.paginate_array(Event.get_similar_events(@event.tags)).page(params[:similar])
  end

  def attend_event        #allows user to attend event without any invitation
    event_id = params[:event_id]
    user_id = params[:user_id]
    event = Event.find(event_id)
    user = User.find(user_id)
    check = Attendee.attend_event(user,event)
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end
  end 

  def invite_search      #availabel for event creating user under admin console before event is confirmed
                         #by admin and on confirmation is availabel for any user on logged in event info page
    @event_id = params[:event_id]
  end

  def invite_search_results    #user can search and invite only his friends and people who share mutual interests
    search_key = params[:search_key]
    search_type = params[:search_type]
    @event_id = params[:event_id]
    user = User.find(current_user.id)  
    if search_type == 'text' 
      @results = user.search_friends(search_key)
    elsif search_type == 'interest'
      @results = user.interest_based_search(search_key)
    end
  end

  def invite_user       #allows user to invite other users to event
    user_id = params[:user_id]
    event_id = params[:event_id]
    @event = Event.find(event_id)
    @user = User.find(user_id)
    @event_user_status = @event.event_user_status(@user)
  end

  def invite            #send invitation to other user
    user_id = params[:user_id]
    event_id = params[:event_id]
    event = Event.find(event_id)
    user = User.find(user_id)
    invitor = User.find(current_user.id)
    check = Attendee.send_invitations(invitor,user,event)
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end  
  end

  def accept_invitation      #allows user to accept the invitation sent by other users
    event_id = params[:event_id]
    event = Event.find(event_id)
    check = Attendee.accept_invitation(current_user,event)
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end  
  end

  def maybe_invitation      #allows user to maybe the invitation sent by other users
    event_id = params[:event_id]
    event = Event.find(event_id)
    check = Attendee.maybe_invitation(current_user,event)
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end  
  end

  def reject_invitation     #allows user to reject the invitation sent by other users
    event_id = params[:event_id]
    event = Event.find(event_id)
    check = Attendee.reject_invitation(current_user,event)
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end  
  end

  def send_email_invitation      #allows users to invite people to event using email 
    email = params[:email]
    invitor = User.find(params[:invitor_id])
    event = Event.find(params[:event_id])
    Notifier.delay.send_email_invitation(event,invitor,email)
    flash[:notice] = 'Email successfully sent'
    redirect_to(:action=>"event_user", :controller=>"events",:event_id => params[:event_id])

  end

  def invite_via_email              #asks the user invited via email to first sign up and then directs
    user_id = current_user.id     #to invitation accept/reject page
    user = User.find(user_id)
    event_id = params[:event_id]
    event = Event.find(event_id)
    invitor_id = params[:invitor_id]
    invitor = User.find(invitor_id)
    check = Attendee.send_invitations(invitor,user,event)
    if check 
      redirect_to(:action=>"pending_invitations", :controller=>"users")
    end
  end  
end
