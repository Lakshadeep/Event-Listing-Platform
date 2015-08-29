class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
    	t.integer "event_id" 
    	t.attachment "event_pic" 

      t.timestamps
    end
  end
end
