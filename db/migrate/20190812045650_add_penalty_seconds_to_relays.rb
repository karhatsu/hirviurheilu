class AddPenaltySecondsToRelays < ActiveRecord::Migration[5.2]
  def change
    add_column :relays, :penalty_seconds, :integer
  end
end
