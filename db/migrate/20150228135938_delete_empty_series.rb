class DeleteEmptySeries < ActiveRecord::Migration
  def up
    Series.joins(:race).where('competitors_count=? and races.finished=?', 0, true).destroy_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
