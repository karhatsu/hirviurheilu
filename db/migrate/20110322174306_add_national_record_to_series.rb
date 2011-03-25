class AddNationalRecordToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :national_record, :integer
  end

  def self.down
    remove_column :series, :national_record
  end
end
