class AddRevealDistancesToRaces < ActiveRecord::Migration[6.0]
  def change
    add_column :races, :reveal_distances, :boolean, null: false, default: false
  end
end
