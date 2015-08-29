class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
    	t.string "name", :null => false
    	t.string "email", :null => false
    	t.string "password", :null => false
    	t.boolean "is_admin", :default => false 
      t.boolean "is_blocked",:default => false 
		  t.timestamps
    end
  end
  def down
  	drop_table users
  end
end
