class AddBatchToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :batch_size, :integer
    add_column :races, :batch_interval_seconds, :integer
  end

  def self.down
    remove_column :races, :batch_size
    remove_column :races, :batch_interval_seconds
  end
end
