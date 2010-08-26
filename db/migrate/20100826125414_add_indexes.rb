class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :shots, :competitor_id
    add_index :competitors, :series_id
    add_index :series, :race_id
    add_index :races, :sport_id
    add_index :users, :email
  end

  def self.down
    remove_index :shots, :column => :competitor_id
    remove_index :competitors, :column => :series_id
    remove_index :series, :column => :race_id
    remove_index :races, :column => :sport_id
    #remove_index :users, :column => :email
  end
end
