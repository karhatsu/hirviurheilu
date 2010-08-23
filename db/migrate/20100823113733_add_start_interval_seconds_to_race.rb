class AddStartIntervalSecondsToRace < ActiveRecord::Migration
  def self.up
    add_column :races, :start_interval_seconds, :integer
  end

  def self.down
    remove_column :races, :start_interval_seconds
  end
end
