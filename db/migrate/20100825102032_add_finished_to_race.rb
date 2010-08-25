class AddFinishedToRace < ActiveRecord::Migration
  def self.up
    add_column :races, :finished, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :races, :finished
  end
end
