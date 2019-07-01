class AddNewAdjustmentsToRelayCompetitors < ActiveRecord::Migration[5.2]
  def change
    add_column :relay_competitors, :estimate_penalties_adjustment, :integer
    add_column :relay_competitors, :shooting_penalties_adjustment, :integer
  end
end
