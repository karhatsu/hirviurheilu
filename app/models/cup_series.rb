class CupSeries < ActiveRecord::Base
  belongs_to :cup
  
  validates :name, :presence => true

  def series
    @series ||= pick_series_with_given_name
  end
  
  def has_single_series_with_same_name?
    series_names.blank? or name == series_names
  end
  
  def cup_competitors
    @cup_competitors ||= pick_competitors_with_same_name_in_all_races
  end
  
  def ordered_competitors
    cup_competitors.sort do |a, b|
      [b.points.to_i, b.points!.to_i] <=> [a.points.to_i, a.points!.to_i]
    end
  end
  
  private
  def pick_series_with_given_name
    series = []
    cup.races.each do |race|
      race.series.where(:name => series_names_as_array).each do |s|
        series << s
      end
    end
    series
  end
  
  def series_names_as_array
    return series_names.strip.split(',') unless series_names.blank?
    [name]
  end
  
  def pick_competitors_with_same_name_in_all_races
    name_to_competitor = Hash.new
    series.each do |s|
      s.competitors.each do |competitor|
        name = CupCompetitor.name(competitor)
        if name_to_competitor.has_key?(name)
          name_to_competitor[name] << competitor
        else
          name_to_competitor[name] = CupCompetitor.new(self, competitor)
        end
      end
    end
    name_to_competitor.values
  end
end