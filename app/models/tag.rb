class Tag < ActiveRecord::Base
  attr_accessible :tag
  has_and_belongs_to_many :events, :join_table => "events_tags", :foreign_key => "tag_id"
  has_and_belongs_to_many :users, :join_table => "users_tags", :foreign_key => "tag_id"
end
