class Team
  attr_reader :name, :club_id, :competitors

  def initialize(team_competition, name, club_id)
    @team_competition = team_competition
    @sport = team_competition.sport
    @name = name
    @club_id = club_id
    @competitors = []
  end

  def race
    @team_competition.race
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
    @competitors.map {|c| c.shooting_score.to_i}.max
  end

  def fastest_time
    @competitors.select {|c| c.time_in_seconds}.map {|c| c.time_in_seconds}.min
  end

  def hits
    @competitors.map {|c| c.hits.to_i}.inject(:+)
  end

  def shot_counts
    counts = Array.new(10).fill(0)
    @competitors.each do |c|
      (c.shots || []).each do |shot|
        index = 10 - (shot == 11 ? 10 : shot)
        counts[index] = counts[index] + 1 if shot > 0
      end
    end
    counts
  end

  def extra_shots
    return [] if @team_competition.max_extra_shots == 0
    own = @team_competition.extra_shots.find {|x| x['club_id'] == @club_id}
    own_shots = own ? own['shots'] : []
    own_shots + Array.new(@team_competition.max_extra_shots - own_shots.length, 0)
  end

  def national_record_reached?
    @team_competition.national_record && total_score.to_i == @team_competition.national_record.to_i
  end

  def national_record_passed?
    @team_competition.national_record && total_score.to_i > @team_competition.national_record.to_i
  end
end
