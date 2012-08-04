class CupCompetitor
  def initialize(cup_series, competitor)
    @cup_series = cup_series
    @competitors = [competitor]
  end
  
  def first_name
    @competitors.first.first_name
  end
  
  def last_name
    @competitors.first.last_name
  end
  
  def series_name
    @competitors.first.series.name
  end
  
  def <<(competitor)
    raise "Competitor name (#{name(competitor)}) should be #{name(self)}" unless name(competitor) == name(self)
    @competitors << competitor
  end
  
  def competitors
    @competitors
  end
  
  def competitor_for_race(race)
    @competitors.select { |c| c.race == race }.first
  end
  
  def points
    total_points @cup_series.cup.top_competitions
  end
  
  def points!
    total_points 1
  end
  
  def points_array
    @points_array ||= @competitors.collect { |c| c.points(false) }
  end
  
  def self.name(competitor)
    "#{competitor.last_name.strip} #{competitor.first_name.strip}".downcase
  end

  private
  def name(competitor)
    CupCompetitor.name(competitor)
  end
  
  def total_points(min_competitions)
    return sum_of_top_competitions if count_non_nil_points >= min_competitions
    nil
  end
  
  def count_non_nil_points
    points_array.select { |p| !p.nil? }.length
  end
  
  def sum_of_top_competitions
    points_array.collect {|p| p.to_i }.sort.reverse[0, @cup_series.cup.top_competitions].inject(:+)
  end
end
