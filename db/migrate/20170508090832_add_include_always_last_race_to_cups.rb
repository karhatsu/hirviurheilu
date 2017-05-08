class AddIncludeAlwaysLastRaceToCups < ActiveRecord::Migration
  def change
    add_column :cups, :include_always_last_race, :boolean, default: false, null: false
  end
end
