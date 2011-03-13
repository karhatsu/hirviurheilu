class AddNoResultReasonToRelayTeams < ActiveRecord::Migration
  def self.up
    add_column :relay_teams, :no_result_reason, :string
  end

  def self.down
    remove_column :relay_teams, :no_result_reason
  end
end
