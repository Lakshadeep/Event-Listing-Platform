class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout :get_layout

  
  
  def location      #asks user if he wants location based event suggestions or not
  end

  def search       
  end

  def home                 #logged in home page
    if params[:lat].present? && params[:lng]
      lat = params[:lat].to_f
      lng = params[:lng].to_f
      @location_based_events = Event.get_location_based_event_list(lat,lng,5).page params[:location_based]
    else
      @location_based_events = Kaminari.paginate_array([]).page(params[:location_based])
    end
    @user_intereste_based_events = Kaminari.paginate_array(Event.get_similar_events(User.find(current_user.id).tags)).page(params[:interest_based])
  end

  def search_results     
    search_key = params[:search_key]
    search_type = params[:search_type]  
    if search_type == 'text' 
      @results = User.search(search_key: search_key,text: true)
    elsif search_type == 'tag'
      category = params[:category]
      category_int = category.collect do |x|
        Tag.find(x.to_i)
      end
      @results = User.search(tag: true,tags_array: category_int)
    end
  end

  def send_friend_request    
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]
    sender = User.find(sender_id)
    receiver = User.find(receiver_id)
    check = Friend.send_friend_request(sender,receiver)
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end
  end

  def accept_friend_request
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]
    sender = User.find(sender_id.to_i)
    receiver = User.find(receiver_id.to_i)
    check = Friend.accept_friend_request(sender,receiver)
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end
  end

  def reject_friend_request
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]
    sender = User.find(sender_id.to_i)
    receiver = User.find(receiver_id.to_i)
    check = Friend.reject_friend_request(sender,receiver)
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end
  end

  def pending_friend_requests       #gives the list of pending friend requests for the user
    user_id = current_user.id
    user = User.find(user_id)
    pending_requests_ids = Friend.get_pending_friend_requests(user)
    @pending_requests = User.find(:all,:conditions=>{:id => pending_requests_ids.collect { |y| y.sender_id }})
  end
    
  def pending_invitations            #gives the list of pending event invitations for the user
    user_id = current_user.id
    user = User.find(user_id)
    @pending_invitations = user.get_user_event_list("invitation_sent")
  end

  def user_public                   #user profile visible to his non -friend users
    user_id = params[:user_id]
    @user = User.find(params[:user_id])
    @events = @user.get_user_created_events()
    sender = User.find(current_user.id)
    friend_list = Friend.get_friends_list(sender)
    friend_check = [@user.id] - friend_list
    if !friend_check.empty?  
      @friend_status = Friend.get_friend_status(@user,sender) == "pending" ? "request_sent" : Friend.get_friend_status(sender,@user)
    else
      @friend_status = 'friends'
    end
    @user_friend_list = Friend.get_friends_list(@user)
  end

  def user_friends                 #user profile visile to  friends   
    user_id = params[:user_id]
    if Friend.get_friends_list(current_user).include?params[:user_id].to_i
      @user = User.find(params[:user_id])
      @events = @user.get_user_created_events()
      sender = User.find(current_user.id)
      @friend_status = 'friends'
      @attending_events = @user.get_user_event_list("confirmed")
      @invited_for_events = @user.get_user_event_list("invitation_sent")
    else
      flash[:alert] = 'You are not friends with that user'
      redirect_to(:action=>"index", :controller=>"publics")
    end
  end

  def user_info                   #decides which user info page to use based on viewing user is friends or not of
                                  #user profile being viewed
    if Friend.get_friends_list(current_user).include?params[:user_id].to_i
      redirect_to(:action=>"user_friends", :controller=>"users",:user_id=> params[:user_id])
    else
      redirect_to(:action=>"user_public", :controller=>"users",:user_id=> params[:user_id])
    end
  end

  
  def profile               #displays the users own profile,with list of events created,attending and invited
    @events = current_user.get_user_created_events()
    @attending_events = current_user.get_user_event_list("confirmed")
    @invited_for_events = current_user.get_user_event_list("invitation_sent")
  end

  def friends              #displays the lsit of users friends
    friends_ids = Friend.get_friends_list(current_user)
    @friends = User.find(:all,:conditions=>{:id => friends_ids})

  end

end
