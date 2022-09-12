class AddNordicSubResultsForSeriesToRaces < ActiveRecord::Migration[7.0]
  def change
    add_column :races, :nordic_sub_results_for_series, :boolean
  end
end
