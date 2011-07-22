class AddClubLevelToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :club_level, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :races, :club_level
  end
end
