class Team
  attr_reader :name, :competitors

  def initialize(sport, name)
    @sport = sport
    @name = name
    @competitors = []
  end

  def <<(competitor)
    @competitors << competitor
  end

  def total_score
    @competitors.map {|c| c.team_competition_points(@sport)}.inject(:+)
  end

  def best_competitor_score
    @competitors[0].team_competition_points @sport
  end

  def best_shooting_score
    @competitors.map {|c| c.shooting_score}.max
  end

  def fastest_time
    @competitors.select {|c| c.time_in_seconds}.map {|c| c.time_in_seconds}.min
  end
end
