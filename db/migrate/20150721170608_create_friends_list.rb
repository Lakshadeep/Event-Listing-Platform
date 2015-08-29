class CreateFriendsList < ActiveRecord::Migration
  def up
  	create_table :friends do |t|
  		t.integer "sender_id", :null => false
  		t.integer "receiver_id", :null => false
  		t.boolean "status", :null => false
    end
    execute <<-SQL
      ALTER TABLE friends
        ADD CONSTRAINT fk_friend_sender
        FOREIGN KEY (sender_id)
        REFERENCES users(id),
        ADD CONSTRAINT fk_friend_receiver
        FOREIGN KEY (receiver_id)
        REFERENCES users(id)
    SQL
    add_index :friends, ["sender_id","receiver_id"], :unique => true
    
  end

  def down
    execute <<-SQL
      ALTER TABLE friends
        DROP CONSTRAINT fk_friend_sender,
        DROP CONSTRAINT fk_friend_receiver
        
    SQL
  	drop_table :friends
  end
end

