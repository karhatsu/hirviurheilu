class AddSportKeyToRaces < ActiveRecord::Migration[5.2]
  def up
    add_column :races, :sport_key, :string
    Race.where('sport_id=1').update_all("sport_key='RUN'")
    Race.where('sport_id=2').update_all("sport_key='SKI'")
    change_column_null :races, :sport_id, true
  end

  def down
    remove_column :races, :sport_key
    change_column_null :races, :sport_id, false
  end
end
