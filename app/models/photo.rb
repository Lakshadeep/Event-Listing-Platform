class Photo < ActiveRecord::Base
  attr_accessible  :event_pic
  has_and_belongs_to_many  :events ,:join_table  => "events_photos", :foreign_key => "photo_id"
  has_attached_file :event_pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :event_pic, :content_type => /\Aimage\/.*\Z/
end
