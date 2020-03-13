class AddFinalRoundBatchToCompetitors < ActiveRecord::Migration[6.0]
  def change
    rename_column :competitors, :batch_id, :qualification_round_batch_id
    add_reference :competitors, :final_round_batch, index: true
  end
end
