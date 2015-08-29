class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
    	t.string "tag", :null => false 

		  t.timestamps
    end
  end
  def down
  	drop_table :tags
  end
end
