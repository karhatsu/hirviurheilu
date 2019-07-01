class AddDistancesToRelays < ActiveRecord::Migration[5.2]
  def change
    add_column :relays, :leg_distance, :integer
    add_column :relays, :estimate_penalty_distance, :integer
    add_column :relays, :shooting_penalty_distance, :integer
  end
end
