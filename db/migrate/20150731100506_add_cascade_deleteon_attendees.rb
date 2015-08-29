class AddCascadeDeleteonAttendees < ActiveRecord::Migration
  def up
  	execute <<-SQL
      ALTER TABLE attendees
        DROP CONSTRAINT fk_event
    SQL
  	execute <<-SQL
      ALTER TABLE attendees
        ADD CONSTRAINT fk_event
        FOREIGN KEY (event_id)
        REFERENCES events(id) on delete cascade
    SQL
  end

  def down
  	execute <<-SQL
      ALTER TABLE attendees
        DROP CONSTRAINT fk_event
    SQL
  end
end
