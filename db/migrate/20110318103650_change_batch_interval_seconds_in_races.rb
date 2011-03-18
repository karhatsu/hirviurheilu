class ChangeBatchIntervalSecondsInRaces < ActiveRecord::Migration
  def self.up
    change_column :races, :batch_interval_seconds, :integer, :null => false, :default => 180
  end

  def self.down
    change_column :races, :batch_interval_seconds, :integer, :null => true, :default => nil
  end
end
