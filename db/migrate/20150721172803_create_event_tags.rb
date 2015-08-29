class CreateEventTags < ActiveRecord::Migration
  def up
  	create_table :events_tags, :id => false do |t|
  		t.integer "event_id", :null => false
  		t.integer "tag_id", :null => false
    end

    execute <<-SQL
      ALTER TABLE events_tags
        ADD CONSTRAINT fk_event_tags
        FOREIGN KEY (event_id)
        REFERENCES events(id)
    SQL

    add_index :events_tags, ["event_id","tag_id"], :unique => true
    
  end

  def down
    execute <<-SQL
      ALTER TABLE events_tags
        DROP CONSTRAINT fk_event_tags
    SQL
  	drop_table :events_tags
  end
end
