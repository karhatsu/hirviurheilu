class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.date :published, :null => false
      t.string :title, :null => false
      t.string :content, :null => false
      t.boolean :active, :null => false, :default => false
      t.timestamps
    end
  end
end
