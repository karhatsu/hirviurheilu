class ChangeAnnouncementContentToText < ActiveRecord::Migration
  def change
    change_column :announcements, :content, :text, :null => false
  end
end
