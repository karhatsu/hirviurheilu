class ChangeRelayCorrectEstimates < ActiveRecord::Migration
  def self.up
    change_column :relay_correct_estimates, :distance, :integer, :null => true
    add_column :relay_correct_estimates, :leg, :integer, :null => false, :default => 1
  end

  def self.down
    change_column :relay_correct_estimates, :distance, :integer, :null => false
    remove_column :relay_correct_estimates, :leg
  end
end
