class AddPointsMethodToSeries < ActiveRecord::Migration
  def up
    add_column :series, :points_method, :integer, null: false, default: 0
    execute 'update series set points_method=2 where time_points_type=1'
    execute 'update series set points_method=3 where time_points_type=2'
  end

  def down
    remove_column :series, :points_method
  end
end
