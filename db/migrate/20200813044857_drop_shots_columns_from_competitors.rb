class DropShotsColumnsFromCompetitors < ActiveRecord::Migration[6.0]
  def up
    remove_column :competitors, :shot_0
    remove_column :competitors, :shot_1
    remove_column :competitors, :shot_2
    remove_column :competitors, :shot_3
    remove_column :competitors, :shot_4
    remove_column :competitors, :shot_5
    remove_column :competitors, :shot_6
    remove_column :competitors, :shot_7
    remove_column :competitors, :shot_8
    remove_column :competitors, :shot_9
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
