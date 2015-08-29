class SetDefaultValueforAttendeeStatus < ActiveRecord::Migration
  def up
  	change_column :attendees, :status, :string, :default => "invitation_pending"
  	change_column :attendees, :invitor, :integer, :null => true
  end

  def down
  	change_column :attendees, :invitor, :integer, :null => false
  	change_column :attendees, :status, :string
  end
end
