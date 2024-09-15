class AddMarkdownToAnnouncements < ActiveRecord::Migration[7.1]
  def up
    add_column :announcements, :markdown, :text
    Announcement.all.each do |announcement|
      announcement.markdown = ReverseMarkdown.convert announcement.content
      announcement.save!
    end
    change_column_null :announcements, :content, true
  end

  def down
    change_column_null :announcements, :content, false
    remove_column :announcements, :markdown
  end
end
