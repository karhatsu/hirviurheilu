class Cup < ActiveRecord::Base
  has_and_belongs_to_many :races
  
  validates :name, :presence => true
  validates :top_competitions, :numericality => { :greater_than => 1, :only_integer => true }
  
  def cup_series
    pick_series_with_same_name_in_all_races
  end
  
  def find_cup_series(name)
    (cup_series.select { |cs| cs.name == name }).first
  end
  
  private
  def pick_series_with_same_name_in_all_races
    race_count = races.length
    name_to_cup_series = Hash.new
    races.each do |race|
      race.series.each do |series|
        if name_to_cup_series.has_key?(series.name)
          name_to_cup_series[series.name] << series
        else
          name_to_cup_series[series.name] = CupSeries.new(self, series)
        end
      end
    end
    name_to_cup_series.values.select { |cs| cs.series.length == race_count }
  end
end
