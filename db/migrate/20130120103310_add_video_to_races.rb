class AddVideoToRaces < ActiveRecord::Migration
  def change
    add_column :races, :video_source, :text
    add_column :races, :video_description, :text
  end
end
