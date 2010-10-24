class AddRaceIdToClubs < ActiveRecord::Migration
  def self.up
    add_column :clubs, :race_id, :integer, :null => false, :default => 1
    change_column_default :clubs, :race_id, nil
    add_index :clubs, :race_id
  end

  def self.down
    remove_column :clubs, :race_id
  end
end
