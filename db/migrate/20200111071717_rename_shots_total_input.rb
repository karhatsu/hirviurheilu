class RenameShotsTotalInput < ActiveRecord::Migration[6.0]
  def change
    rename_column :competitors, :shots_total_input, :shooting_score_input
  end
end
