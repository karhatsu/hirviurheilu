class DropSports < ActiveRecord::Migration[6.1]
  def change
    remove_column :races, :sport_id
    drop_table :sports
  end
end
