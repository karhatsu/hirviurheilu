class FixSeriesEstimates < ActiveRecord::Migration[5.1]
  def up
    execute "update series set estimates=4 where points_method in(#{Series::POINTS_METHOD_NO_TIME_4_ESTIMATES}, #{Series::POINTS_METHOD_TIME_4_ESTIMATES})"
    execute "update series set estimates=2 where points_method not in(#{Series::POINTS_METHOD_NO_TIME_4_ESTIMATES}, #{Series::POINTS_METHOD_TIME_4_ESTIMATES})"
  end

  def down
  end
end
