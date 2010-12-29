class AddNoTimePointsToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :no_time_points, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :series, :no_time_points
  end
end
