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

  def hits
    @competitors.map {|c| c.hits}.inject(:+)
  end

  def shot_counts
    counts = Array.new(10).fill(0)
    @competitors.each do |c|
      c.shots.each do |shot|
        index = 10 - (shot == 11 ? 10 : shot)
        counts[index] = counts[index] + 1 if shot > 0
      end
    end
    counts
  end
end
