class RenameBatchesToHeats < ActiveRecord::Migration[7.1]
  def up
    rename_table :batches, :heats
    execute "UPDATE heats SET type='QualificationRoundHeat' WHERE type='QualificationRoundBatch'"
    execute "UPDATE heats SET type='FinalRoundHeat' WHERE type='FinalRoundBatch'"
    rename_column :races, :batch_size, :heat_size
    rename_column :races, :batch_interval_seconds, :heat_interval_seconds
    rename_column :races, :hide_qualification_round_batches, :hide_qualification_round_heats
    rename_column :races, :hide_final_round_batches, :hide_final_round_heats
    rename_column :competitors, :qualification_round_batch_id, :qualification_round_heat_id
    rename_column :competitors, :final_round_batch_id, :final_round_heat_id
  end

  def down
    rename_column :competitors, :final_round_heat_id, :final_round_batch_id
    rename_column :competitors, :qualification_round_heat_id, :qualification_round_batch_id
    rename_column :races, :hide_final_round_heats, :hide_final_round_batches
    rename_column :races, :hide_qualification_round_heats, :hide_qualification_round_batches
    rename_column :races, :heat_interval_seconds, :batch_interval_seconds
    rename_column :races, :heat_size, :batch_size
    execute "UPDATE heats SET type='QualificationRoundBatch' WHERE type='QualificationRoundHeat'"
    execute "UPDATE heats SET type='FinalRoundBatch' WHERE type='FinalRoundHeat'"
    rename_table :heats, :batches
  end
end
