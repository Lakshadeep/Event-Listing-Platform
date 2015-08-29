class SetDefaultValueforFriendsStatus < ActiveRecord::Migration
  def up
  	change_column :friends, :status, :string, :default => "pending"
  end

  def down
  	change_column :friends, :status, :string
  end
end
