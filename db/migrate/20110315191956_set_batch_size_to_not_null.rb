class SetBatchSizeToNotNull < ActiveRecord::Migration
  def self.up
    change_column :races, :batch_size, :integer, :null => false, :default => 0
  end

  def self.down
    change_column :races, :batch_size, :integer, :null => true
  end
end
