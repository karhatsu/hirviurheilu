class AddStartTimeToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :start_time, :datetime
  end

  def self.down
    remove_column :series, :start_time
  end
end
