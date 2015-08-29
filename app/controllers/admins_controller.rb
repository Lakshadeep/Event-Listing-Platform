class AdminsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource :class => false 
   
  layout :get_layout

	def search_admin            #allows admin to search and unblock/block users
  end

  def search_results_admin     
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

  def user_admin               #user profile as visible to admin
    user_id = params[:user_id]
    @user = User.find(user_id)
    @events = @user.get_user_created_events()
    # @friends = User.find(:all,:conditions=>{:id => friends_ids})
    @attending_events = @user.get_user_event_list("confirmed")
    @invited_for_events = @user.get_user_event_list("invitation_sent")
  end

  def block_user               
    user_id = params[:user_id]
    user = User.find(user_id)
    check =  user.block_user()
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end
  end

  def unblock_user
    user_id = params[:user_id]
    user = User.find(user_id)
    check =  user.unblock_user()
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end
  end

  def non_confirmed_events            #gives the list of non confirmed events
    @non_confirmed_events = Event.get_not_confirmed_events_list()
  end

  def confirm_event                       #confirms the event
    event_id = params[:event_id]
    event = Event.find(event_id)
    check = event.confirm_event()
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end 
  end

  def delete_event                       #deletes the event
    event_id = params[:event_id]
    event = Event.find(event_id)
    check = event.delete_event()
    if check
      render :json => { :status => :ok, :message => "Success!", :html => "...insert html..." }
    end 
  end

end
