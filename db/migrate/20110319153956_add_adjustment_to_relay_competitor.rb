class AddAdjustmentToRelayCompetitor < ActiveRecord::Migration
  def self.up
    add_column :relay_competitors, :adjustment, :integer
  end

  def self.down
    remove_column :relay_competitors, :adjustment
  end
end
