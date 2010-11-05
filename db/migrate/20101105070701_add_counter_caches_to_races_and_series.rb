class AddCounterCachesToRacesAndSeries < ActiveRecord::Migration
  def self.up
    add_column :races, :series_count_temp, :integer, :null => false, :default => 0
    Race.reset_column_information
    Race.all.each do |race|
      race.update_attribute :series_count_temp, race.series.length
    end
    rename_column :races, :series_count_temp, :series_count

    add_column :series, :competitors_count_temp, :integer, :null => false, :default => 0
    Series.reset_column_information
    Series.all.each do |series|
      series.update_attribute :competitors_count_temp, series.competitors.length
    end
    rename_column :series, :competitors_count_temp, :competitors_count
  end

  def self.down
    remove_column :races, :series_count
    remove_column :series, :competitors_count
  end
end
