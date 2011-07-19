class ChangeNoTimePointsToInteger < ActiveRecord::Migration
  def self.up
    add_column :series, :time_points_type, :integer, :null => false, :default => 0
    execute 'update series set time_points_type=1 where no_time_points=true'
    execute 'update series set time_points_type=0 where no_time_points=false'
    remove_column :series, :no_time_points
  end

  def self.down
    add_column :series, :no_time_points, :boolean, :null => false, :default => false
    execute 'update series set no_time_points=true where time_points_type=1'
    execute 'update series set no_time_points=false where time_points_type=0'
    remove_column :series, :time_points_type
  end
end
