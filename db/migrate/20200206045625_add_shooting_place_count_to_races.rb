class AddShootingPlaceCountToRaces < ActiveRecord::Migration[6.0]
  def change
    add_column :races, :shooting_place_count, :integer
  end
end
