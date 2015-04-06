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
      a_points = a.points_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      b_points = b.points_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      a_sort_params = [a.points!.to_i] + a_points
      b_sort_params = [b.points!.to_i] + b_points
      b_sort_params <=> a_sort_params
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