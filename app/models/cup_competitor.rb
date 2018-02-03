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

  def club_name
    @competitors.first.club.name
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
    total_points @cup_series.cup.top_competitions, @cup_series.cup.include_always_last_race?
  end
  
  def points!
    total_points 1, false
  end
  
  def points_array
    @points_array ||= points_with_last_race_info_array.map {|item| item[:points]}
  end
  
  def self.name(competitor)
    "#{competitor.last_name.strip} #{competitor.first_name.strip}".downcase
  end

  private
  def name(competitor)
    CupCompetitor.name(competitor)
  end

  def points_with_last_race_info_array
    @points_array_with_last_race_info ||= @competitors.map { |c| {points: c.points, last_cup_race: c.series.last_cup_race} }
  end
  
  def total_points(min_competitions, last_race_required)
    return nil if (last_race_required && last_race_missing?) || count_non_nil_points < min_competitions
    sum_of_top_competitions + points_of_last_race
  end

  def last_race_missing?
    last_race_points = points_with_last_race_info_array.find {|item| item[:last_cup_race] }
    !last_race_points || !last_race_points[:points]
  end
  
  def count_non_nil_points
    points_with_last_race_info_array.select { |p| p[:points] && !p[:last_cup_race] }.length
  end
  
  def sum_of_top_competitions
    points_with_last_race_info_array.select{|p| !p[:last_cup_race]}.map {|p| p[:points].to_i }.
        sort.reverse[0, @cup_series.cup.top_competitions].inject(:+)
  end

  def points_of_last_race
    last_race = points_with_last_race_info_array.find {|p| p[:last_cup_race]}
    return 0 unless last_race
    last_race[:points].to_i
  end
end
