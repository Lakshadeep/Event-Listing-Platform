class PublicsController < ApplicationController
  layout :get_layout
  
  def index               #public home page
    @recently_created = Event.get_recently_created_event_list(3).page params[:recently_created_events]
    @upcoming = Event.get_upcoming_events(3).page params[:upcoming_events]
  end

  def search              #search
    search_key = params[:search_key]
    search_type = params[:search_type]  

    if search_type == 'text' 
      @results = Kaminari.paginate_array(Event.search(search_key: search_key,text: true)).page(params[:search_result])
      @heading = "Search results for  "+ search_key

    elsif search_type == 'location'
      search_key = search_key.split(',').map(&:to_f)
      @results = Kaminari.paginate_array(Event.search(location: true,user_lat: search_key[0],user_lng: search_key[1],radius: 100)).page(params[:search_result])
      @heading = "Search results for event nearby latitude "+search_key[0].to_s + " and longitude "+search_key[1].to_s   
    
    elsif search_type == 'date'
      date = Time.zone.parse(search_key+' 00:00')
      @results = Kaminari.paginate_array(Event.search(date_key: date,date: true)).page(params[:search_result])
      @heading = "Search results for events on and after "+search_key
    
    elsif search_type == 'tag'
      category = params[:category]
      category_int = category.collect do |x|
        Tag.find(x.to_i)
      end

      category_string = ""
      category_int.each do |x|
        category_string = category_string + x.tag + ","
      end
      @results = Kaminari.paginate_array(Event.search(tags: true,tags_array:category_int)).page(params[:search_result])
      @heading = "Search results for events belonging to "+category_string
      
    elsif search_type == 'all'
      search_key = params[:search_key];
      lat_lng = params[:lat_lng].empty? ? [0,0] : params[:lat_lng].split(',').map(&:to_f)
      date = params[:date]
      radius = params[:radius].empty? ? 100 : params[:radius].to_i

      if params[:category].nil?
        category_search_check = false
      else
        category = params[:category]
        category_int = category.collect do |x|
          Tag.find(x.to_i)
        end
        category_search_check = true
      end

      text_search_check = search_key.empty? ? false : true
      location_search_check = params[:lat_lng].empty? ? false : true
      date_search_check = date.empty? ? false : true
      
      @results = Kaminari.paginate_array(Event.search(search_key: search_key,date_key: date,radius: radius,text: text_search_check,date: date_search_check,location: location_search_check,tags: category_search_check,user_lat: lat_lng[0],user_lng: lat_lng[1],tags_array: category_int)).page(params[:search_result])
      @heading = "Advanced search results"
    end
  end


  def event_info           #based on logged in status decides which event info page to display
    if user_signed_in?
      redirect_to(:action=>"event_user", :controller=>"events",:event_id=> params[:event_id])
    else
      redirect_to(:action=>"event_public", :controller=>"publics",:event_id=> params[:event_id])
    end
  end

  def event_public          #event info page availabel for public users
    event_id = params[:event_id]
    @event = Event.find(params[:event_id])
    @event_pics = @event.photos
    creator = User.find(@event.creator_id)
    @confirmed_count = Attendee.get_event_status_count(@event,"confirmed")
    @maybe_count = Attendee.get_event_status_count(@event,"maybe")
    @rejected_count = Attendee.get_event_status_count(@event,"rejected")
    @nearby_events = Event.get_location_based_event_list(@event.latitude,@event.longitude,3).page params[:nearby]
    @other_events_by_user = creator.get_user_created_events().page params[:user_created]
    @similar_events = Kaminari.paginate_array(Event.get_similar_events(@event.tags)).page(params[:similar])
  end

  def attendee_list         #gives the list of users confirmed/maybe/not going for that particular event
    @event = Event.find(params[:event_id])
    status_code = params[:status_code].to_i 
    if status_code == 1
      @status = "Users confirmed for "+@event.title
      @results = Attendee.get_event_status_list(@event,"confirmed") 
    elsif status_code == 2
      @status = "Users maybe for "+@event.title
      @results = Attendee.get_event_status_list(@event,"maybe")
    elsif status_code == 3
      @status = "Users not coming for "+@event.title
      @results = Attendee.get_event_status_list(@event,"rejected")
    else
      @status = "No list availabel for this status"
      @results = []
    end
  end 

  def home_redirect                   #decides which home page to use based logged in or not
    if user_signed_in?
      redirect_to(:action=>"location", :controller=>"users")
    else
      redirect_to(:action=>"index", :controller=>"publics")
    end
  end

end
