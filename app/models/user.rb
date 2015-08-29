class User < ActiveRecord::Base 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :id,:name,  :email, :is_admin, :profile_pic,:password,:password_confirmation
  validates :name, :presence => true
  validates_email_format_of :email, :message => 'Please enter correct email'


  has_attached_file :profile_pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/empty_profile.jpg"
  validates_attachment_content_type :profile_pic, :content_type => /\Aimage\/.*\Z/

  has_many :attendees, :foreign_key => "user_id"
  has_many :events, :through => :attendees
  
  has_many :friends,:foreign_key => "sender_id"
  has_many :receivers, :through => :friends
  has_many :reverse_friends, :foreign_key => "receiver_id", class_name: "Friend"
  has_many :senders, :through => :reverse_friends

  has_and_belongs_to_many :tags, :join_table => "users_tags", :foreign_key => "user_id"


  

  def self.create_user(user_hash)
    begin   
      user = User.new(user_hash)
      if user.save
        return [user,"Success"]
      else
        # return [nil,user.errors.full_messages.to_sentence]
        return [nil,user.errors.full_messages.flatten]
      end
      # rescue ActiveRecord::RecordNotUnique  => invalid
      #   return [nil,"This email id already exist"]
      rescue ActiveRecord::RecordInvalid  => e
         return [nil,e.full_messages.flatten]
    end  
  end

  def get_user_created_events
    return Event.where("creator_id = ? and start_time > ? and is_approved=true",self.id,Time.now)
  end

  def get_user_invitation_stats(event)
     invitations_sent = event.attendees.where(invitor: self.id).count
     invitations_responded = event.attendees.where(invitor: self.id).where("status != ?","invitation_sent").count
     return [invitations_sent,invitations_responded]
  end

  def block_user
    Notifier.delay.send_user_blocked_email(self)
    self.is_blocked = true
    return self.save
  end

  def unblock_user
    Notifier.delay.send_user_unblocked_email(self)
    self.is_blocked = false
    return self.save
  end

  def self.search(search_key: nil,text: false,tag: false,tags_array: nil)
    result =[]
    users = User.scoped
    users = text ? users.where("lower(name) LIKE ?","%#{search_key.downcase}%") : users
    if tag
      users.each do |x|
        user_tags = x.tags
        tag_check = tags_array - user_tags
        tag_check.empty? ? result.push(x) : result
      end
      return result
    else
      result = users
      return result
    end
  end
 
  def make_admin
    self.is_admin = true
    self.save
  end 

  def search_friends(search_key)          
    user_friends_ids = Friend.get_friends_list(self)
    result_general = User.where("lower(name) LIKE ?","%#{search_key.downcase}%")
    result = []
    result_general.each do |x|
      if user_friends_ids.include? x.id
        result.push(x)
      end
    end
    return result
  end

  def interest_based_search(search_key)
    return self.search(search_key: search_key,text: true,tag: true,tags_array: self.tags)
  end

  def get_user_event_list(status)
    temp = Attendee.where("user_id = ? and status = ?",self.id,status)
    result = []
    temp.each do |x|
      event = Event.find(x.event_id)
      if event.start_time > Time.now
        invitor = x.invitor.nil? ? nil : User.find(x.invitor)
        result.push([event,invitor])
      end
    end
    return result
  end

  def get_user_events
    return Event.where("creator_id = ? and start_time > ? ",self.id,Time.now)
  end

  def active_for_authentication?
    #remember to call the super
    #then put our own check to determine "active" state using 
    #our own "is_active" column
    super and !self.is_blocked?
  end 

end
