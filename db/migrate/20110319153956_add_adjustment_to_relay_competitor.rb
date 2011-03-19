class AddAdjustmentToRelayCompetitor < ActiveRecord::Migration
  def self.up
    remove_column :series, :start_time, :integer
  end

  def self.down
    remove_column :series, :start_time
  end
end
