class SplitAirSports < ActiveRecord::Migration[6.0]
  def up
    Race.where("sport_key = 'AIR'").update_all("sport_key = 'ILMAHIRVI'")
  end

  def down
    Race.where("sport_key = 'ILMAHIRVI'").update_all("sport_key = 'AIR'")
  end
end
