class AddTrackCountToRaces < ActiveRecord::Migration[6.0]
  def change
    add_column :races, :track_count, :integer
  end
end
