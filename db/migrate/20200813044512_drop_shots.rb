class DropShots < ActiveRecord::Migration[6.0]
  def up
    drop_table :shots
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
