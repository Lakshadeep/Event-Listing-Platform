class UpdatePhotos < ActiveRecord::Migration
  def up
  	remove_column :photos, :event_id
  	create_table :events_photos, :id => false do |t|
  		t.integer "event_id", :null => false
  		t.integer "photo_id", :null => false
    end

    execute <<-SQL
      ALTER TABLE events_photos
        ADD CONSTRAINT fk_event_photos
        FOREIGN KEY (event_id)
        REFERENCES events(id)
    SQL

    add_index :events_photos, ["event_id","photo_id"], :unique => true
  end

  def down
  	execute <<-SQL
      ALTER TABLE events_photos
        DROP CONSTRAINT fk_event_photos
    SQL
  	drop_table :events_photos
  	add_column :photos, :event_id,:integer
  end
end
