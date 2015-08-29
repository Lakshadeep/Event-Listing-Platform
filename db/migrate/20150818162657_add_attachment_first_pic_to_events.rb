class AddAttachmentFirstPicToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :first_pic
    end
  end

  def self.down
    remove_attachment :events, :first_pic
  end
end
