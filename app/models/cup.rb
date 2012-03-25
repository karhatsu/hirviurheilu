class Cup < ActiveRecord::Base
  has_and_belongs_to_many :races
  
  validates :name, :presence => true
  validates :top_competitions, :numericality => { :greater_than => 1, :only_integer => true }
  
  def cup_series
    pick_series_with_same_name_in_all_races
  end
  
  private
  def pick_series_with_same_name_in_all_races
    cup_series = []
    race_count = races.length
    name_to_count = collect_series_counts
    name_to_count.each do |name, count|
      cup_series << CupSeries.new(name) if count == race_count
    end
    cup_series
  end

  def collect_series_counts
    name_to_count = Hash.new
    races.each do |race|
      race.series.each do |series|
        if name_to_count.has_key?(series.name)
          name_to_count[series.name] += 1
        else
          name_to_count[series.name] = 1
        end
      end
    end
    name_to_count
  end
end
