class DeleteEmptySeries < ActiveRecord::Migration
  def up
    Series.joins(:race).where('races.finished=?', true).find_each do |series|
      series.destroy if series.competitors.count == 0
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
