class AddFrontPageToAnnouncements < ActiveRecord::Migration
  def up
    add_column :announcements, :front_page, :boolean
    execute 'update announcements set front_page=active'
  end

  def down
    remove_column :announcements, :front_page
  end
end
