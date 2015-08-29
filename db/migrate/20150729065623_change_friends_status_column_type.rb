class ChangeFriendsStatusColumnType < ActiveRecord::Migration
  def up
  	change_column :friends, :status,  :string
  end

  def down
  	change_column :friends, :status,  :boolean
  end
end
