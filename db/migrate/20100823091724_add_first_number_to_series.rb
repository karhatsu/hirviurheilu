class AddFirstNumberToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :first_number, :integer
  end

  def self.down
    remove_column :series, :first_number
  end
end
