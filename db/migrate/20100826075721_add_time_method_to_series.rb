class AddTimeMethodToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :time_method, :integer, :limit => 1
  end

  def self.down
    remove_column :series, :time_method
  end
end
