class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
    	t.string "title", :null => false
    	t.decimal "latitude"
      t.decimal "longitude"
    	t.string "address", :null => false
    	t.integer "price"
    	t.datetime "start_time", :null => false
    	t.datetime "end_time", :null => false
    	t.integer "total_seats", :null => false
    	t.boolean "is_approved",:default => false 
    	t.integer "count_confirmed_people" 
      t.integer "creator_id", :null => false

     	t.timestamps
    end
  end
  def down
  	drop_table :events
  end

end
