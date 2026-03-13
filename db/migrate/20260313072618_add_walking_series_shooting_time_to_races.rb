class AddWalkingSeriesShootingTimeToRaces < ActiveRecord::Migration[8.1]
  def change
    add_column :races, :walking_series_shooting_time, :integer
  end
end
