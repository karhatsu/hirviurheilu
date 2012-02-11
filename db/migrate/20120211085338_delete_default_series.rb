class DeleteDefaultSeries < ActiveRecord::Migration
  def up
    drop_table :default_age_groups
    drop_table :default_series
  end

  def down
    raise "rollback not supported for this migration"
  end
end
