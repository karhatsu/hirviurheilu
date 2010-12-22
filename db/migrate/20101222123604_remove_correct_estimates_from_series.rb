class RemoveCorrectEstimatesFromSeries < ActiveRecord::Migration
  def self.up
    remove_column :series, :correct_estimate1
    remove_column :series, :correct_estimate2
  end

  def self.down
    add_column :series, :correct_estimate1, :integer
    add_column :series, :correct_estimate2, :integer
  end
end
