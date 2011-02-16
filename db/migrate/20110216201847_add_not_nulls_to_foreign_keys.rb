class AddNotNullsToForeignKeys < ActiveRecord::Migration
  def self.up
    change_column :series, :race_id, :integer, :null => false
    change_column :shots, :competitor_id, :integer, :null => false
  end

  def self.down
    change_column :series, :race_id, :integer
    change_column :shots, :competitor_id, :integer
  end
end
