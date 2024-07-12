class AddShowEuropeanShotgunResultsToRaces < ActiveRecord::Migration[7.1]
  def change
    add_column :races, :show_european_shotgun_results, :boolean, null: false, default: false
  end
end
