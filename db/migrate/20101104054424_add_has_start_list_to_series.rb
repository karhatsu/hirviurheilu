class AddHasStartListToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :has_start_list, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :series, :has_start_list
  end
end
