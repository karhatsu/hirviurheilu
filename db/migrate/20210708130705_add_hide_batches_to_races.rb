class AddHideBatchesToRaces < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :hide_qualification_round_batches, :boolean
    add_column :races, :hide_final_round_batches, :boolean
  end
end
