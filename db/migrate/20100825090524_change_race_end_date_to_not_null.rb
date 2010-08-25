class ChangeRaceEndDateToNotNull < ActiveRecord::Migration
  def self.up
    change_column :races, :end_date, :date, :null => false
  end

  def self.down
    change_column :races, :end_date, :date, :null => true
  end
end
