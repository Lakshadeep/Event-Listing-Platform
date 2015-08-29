# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150819053928) do

  create_table "attendees", :force => true do |t|
    t.integer "event_id",                                   :null => false
    t.integer "user_id",                                    :null => false
    t.string  "status",   :default => "invitation_pending", :null => false
    t.integer "invitor"
  end

  add_index "attendees", ["event_id", "user_id"], :name => "index_attendees_on_event_id_and_user_id", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.string   "title",                                     :null => false
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "address",                                   :null => false
    t.integer  "price"
    t.datetime "start_time",                                :null => false
    t.datetime "end_time",                                  :null => false
    t.integer  "total_seats",                               :null => false
    t.boolean  "is_approved",            :default => false
    t.integer  "count_confirmed_people"
    t.integer  "creator_id",                                :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "first_pic_file_name"
    t.string   "first_pic_content_type"
    t.integer  "first_pic_file_size"
    t.datetime "first_pic_updated_at"
  end

  create_table "events_photos", :id => false, :force => true do |t|
    t.integer "event_id", :null => false
    t.integer "photo_id", :null => false
  end

  add_index "events_photos", ["event_id", "photo_id"], :name => "index_events_photos_on_event_id_and_photo_id", :unique => true

  create_table "events_tags", :id => false, :force => true do |t|
    t.integer "event_id", :null => false
    t.integer "tag_id",   :null => false
  end

  add_index "events_tags", ["event_id", "tag_id"], :name => "index_events_tags_on_event_id_and_tag_id", :unique => true

  create_table "friends", :force => true do |t|
    t.integer "sender_id",                          :null => false
    t.integer "receiver_id",                        :null => false
    t.string  "status",      :default => "pending", :null => false
  end

  add_index "friends", ["sender_id", "receiver_id"], :name => "index_friends_on_sender_id_and_receiver_id", :unique => true

  create_table "photos", :force => true do |t|
    t.string   "event_pic_file_name"
    t.string   "event_pic_content_type"
    t.integer  "event_pic_file_size"
    t.datetime "event_pic_updated_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "tag",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                        :null => false
    t.string   "email",                                       :null => false
    t.boolean  "is_admin",                 :default => false
    t.boolean  "is_blocked",               :default => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "profile_pic_file_name"
    t.string   "profile_pic_content_type"
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
    t.string   "encrypted_password",       :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_tags", :id => false, :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "tag_id",  :null => false
  end

  add_index "users_tags", ["user_id", "tag_id"], :name => "index_users_tags_on_user_id_and_tag_id", :unique => true

end
