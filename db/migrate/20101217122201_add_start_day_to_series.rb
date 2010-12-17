class AddStartDayToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :start_day, :integer, :null => false, :default => 1
    change_column :series, :start_time, :time
  end

  def self.down
    remove_column :series, :start_day
    change_column :series, :start_time, :datetime
  end
end
