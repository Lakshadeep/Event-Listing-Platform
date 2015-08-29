class CreateAttendees < ActiveRecord::Migration
  def up
  	create_table :attendees do |t|
    	t.integer "event_id", :null => false  
    	t.integer "user_id", :null => false
    	t.string "status", :null => false 
      t.integer "invitor", :null => false
    end
    execute <<-SQL
      ALTER TABLE attendees
        ADD CONSTRAINT fk_event
        FOREIGN KEY (event_id)
        REFERENCES events(id) on delete cascade,
        ADD CONSTRAINT fk_users
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    SQL

    add_index :attendees, ["event_id","user_id"], :unique => true
  end

  def down
    execute <<-SQL
      ALTER TABLE attendees
        DROP CONSTRAINT fk_event,
        DROP CONSTRAINT fk_users
    SQL

  	drop_table :attendees
  end
end

