class AddSubSeriesToCompetitor < ActiveRecord::Migration
  def self.up
    add_column :competitors, :sub_series_id, :integer
  end

  def self.down
    remove_column :competitors, :sub_series_id
  end
end
