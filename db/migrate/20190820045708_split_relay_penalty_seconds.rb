class SplitRelayPenaltySeconds < ActiveRecord::Migration[5.2]
  def change
    rename_column :relays, :penalty_seconds, :estimate_penalty_seconds
    add_column :relays, :shooting_penalty_seconds, :integer
  end
end
