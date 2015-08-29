class Event < ActiveRecord::Base
  attr_accessible :title,:location, :address, :price, :start_time, :end_time, :total_seats, :is_approved, :count_confirmed_people, :creator_id, :latitude, :longitude
  validates :title, :presence => true
  validates :price, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :total_seats, :presence => true
  validates :address, format: { with: /\A[a-zA-Z0-9,-.' ']+\z/, message: "alphanumerice text with space , . -" }

  validate  :validate_start_time
  validate  :validate_end_time

  has_many :attendees, :foreign_key => "event_id",:dependent => :destroy
  has_many :users, :through => :attendees
  
  has_and_belongs_to_many :tags, :join_table => "events_tags", :foreign_key => "event_id"

  has_and_belongs_to_many  :photos, :join_table => "events_photos",:foreign_key => "event_id"

  has_attached_file :first_pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :first_pic, :content_type => /\Aimage\/.*\Z/

  include PgSearch
  pg_search_scope(
    :search_scope,
    against: %i(
      title
      address
    ),
    using: {
      tsearch: {
        dictionary: "english",
      }
    }
  )

  def self.create_event(event_hash)
    event = Event.new(event_hash)
    event_check = event.save
    if event_check 
      admin_list = User.where("is_admin = true")
      admin_list.each do |x|
        Notifier.delay.new_event_created_email(event,x)
      end
      return [event,"Success"]
    else
      return [nil,event]
    end
  end

  def self.get_not_confirmed_events_list()
    return Event.where("is_approved = ? and start_time >= ?", false,Time.now)
  end
  
  def confirm_event()
    user = User.find(self.creator_id)
    self.is_approved = true
    Notifier.delay.send_event_accepted_email(user,self)
    confirm_event_check = self.save
    if confirm_event_check
      pending_invitations = Attendee.where("event_id = ? and status = ?",self.id,'invitation_pending')
      pending_invitations.each do |x|
        user_id = x.user_id
        user = User.find(user_id)
        Notifier.delay.invited_for_event_email(user,self)
        x.status = "invitation_sent"
        x.save
      end
      return true
    else
      return false
    end
  end

  def delete_event()
    user = User.find(self.creator_id)
    Notifier.delay.send_event_rejected_email(user,self)
    self.destroy
    return self.destroyed?
  end
  
  def self.get_recently_created_event_list(limit_count)
    return Event.where("is_approved=true and start_time >= ?",Time.now).order('created_at DESC').limit(limit_count)
  end

  def self.get_upcoming_events(limit_count)
    return Event.where("start_time >= ? and is_approved=true",Time.now).order('start_time ASC').limit(limit_count)
  end

  def self.get_location_based_event_list(user_lat,user_lng,limit_count)
    return Event.where("latitude- ? < 1.0 and longitude - ?< 1.0 and is_approved=true and start_time >= ?",user_lat,user_lng,Time.now).limit(limit_count)
  end

  def self.get_similar_events(interest_array)
    result =[]
    interest_array.each  do |x|
      tag_events  = x.events.where("start_time >= ? and is_approved=true",Time.now)
      tag_events.each do |y|
        if result.include? y
        else
          result.push(y)  
        end 
      end    
    end   
    return result
  end

  def self.search(search_key: nil, date_key: nil, radius: nil, text: false, date: false, location: false, tags:  false, user_lat:  nil, user_lng: nil, tags_array:  nil)
    result =[]
    events = Event.scoped
    events = events.where("is_approved=true and start_time >= ?",Time.now)
    events = date ? events.where("start_time >= ? ",date_key) : events
    # events = location ? events.where("latitude- ? < 1.0 and longitude - ?< 1.0 ",user_lat,user_lng) : events

    rank = <<-RANK
      ts_rank(to_tsvector(title),plainto_tsquery(#{sanitize(search_key)})) +  ts_rank(to_tsvector(address),plainto_tsquery(#{sanitize(search_key)}))
    RANK
    events = text ? events.where(" title @@ :q or address @@:q",q: search_key).order("#{rank} desc") : events
    
    result_location = []
    if location
      events.each do |x|
        self.calculate_distance(x.latitude,x.longitude,user_lat,user_lng) < radius ? result_location.push(x) : ""
      end
    else
      result_location = events
    end 

    if tags
      result_location.each do |x|
        event_tags = x.tags
        tag_check = tags_array - event_tags
        tag_check.empty? ? result.push(x) : result
      end
      return result
    else
      result = result_location
      return result
    end
  end

  def event_user_status(user)    #gives the event and any user status
    attendees_list = Attendee.where("event_id = ? and user_id = ?",self.id,user.id)
    if attendees_list.length != 0
      return attendees_list[0].status
    else
      return "no_data"
    end
  end

  def self.calculate_distance(lat1,lng1,lat2,lng2)         
    dLat = (lat2-lat1) * Math::PI / 180 
    dLon = (lng2-lng1) * Math::PI / 180 
    lat1 = lat1 * Math::PI / 180 
    lat2 = lat2 * Math::PI / 180 
    a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2) 
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = 6371  * c
  end  

  def validate_start_time()
    if !self.start_time.nil?
      if self.start_time < Time.now
        self.errors.add(:base, "Event start time should be in future")
      end
    end
  end

  def validate_end_time()
    if !self.start_time.nil? and !self.end_time.nil?
      if self.end_time < self.start_time
        self.errors.add(:base, "Event end time should be after event start time")
      end
    end
  end

  # def self.load_photos()
  #   e = Event.all
  #   e.each do |x|
  #     x.first_photo_file_name = x.photos.first.event_pic_file_name
  #     x.first_photo_content_type = x.photos.first.event_pic_content_type
  #     x.first_photo_file_name = x.photos.first.event_pic_file_name
  #     x.first_photo_file_name = x.photos.first.event_pic_file_name
  #     x.save
  #   end

  # end

end