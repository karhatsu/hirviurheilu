class AddTwoMoreEstimates < ActiveRecord::Migration
  def self.up
    add_column :series, :estimates, :integer, :null => false, :default => 2
    add_column :correct_estimates, :distance3, :integer
    add_column :correct_estimates, :distance4, :integer
    add_column :competitors, :estimate3, :integer
    add_column :competitors, :estimate4, :integer
    add_column :competitors, :correct_estimate3, :integer
    add_column :competitors, :correct_estimate4, :integer
  end

  def self.down
    remove_column :series, :estimates
    remove_column :correct_estimates, :distance3
    remove_column :correct_estimates, :distance4
    remove_column :competitors, :estimate3
    remove_column :competitors, :estimate4
    remove_column :competitors, :correct_estimate3
    remove_column :competitors, :correct_estimate4
  end
end
