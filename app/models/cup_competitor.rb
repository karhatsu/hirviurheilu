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
  
  def <<(competitor)
    raise "Competitor name (#{name(competitor)}) should be #{name(self)}" unless name(competitor) == name(self)
    @competitors << competitor
  end
  
  def competitors
    @competitors
  end
  
  def points
    top_competitions = @cup_series.cup.top_competitions
    total_competitions = @competitors.length
    points_in_competitions = @competitors.collect { |c| c.points(false).to_i }
    points_in_competitions.sort.reverse[0, top_competitions].inject(:+)
  end
  
  def self.name(competitor)
    "#{competitor.last_name} #{competitor.first_name}"
  end

  private
  def name(competitor)
    CupCompetitor.name(competitor)
  end
end