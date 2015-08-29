class CreateUserTags < ActiveRecord::Migration
  def up
  	create_table :users_tags, :id => false do |t|
  		t.integer "user_id", :null => false
  		t.integer "tag_id", :null => false
    end

    execute <<-SQL
      ALTER TABLE users_tags
        ADD CONSTRAINT fk_user_tags
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    SQL


    add_index :users_tags, ["user_id","tag_id"], :unique => true
    
  end

  def down
    execute <<-SQL
      ALTER TABLE users_tags
        DROP CONSTRAINT fk_user_tags
    SQL
  	drop_table :users_tags
  end
end