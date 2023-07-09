class CupTeam
  include CupPoints

  def initialize(cup_team_competition, team)
    @cup_team_competition = cup_team_competition
    @teams = [team]
  end

  def <<(team)
    raise "Team name (#{team.name}) should be #{name}" unless team.name.strip.downcase == name.strip.downcase
    @teams << team
  end

  def teams
    @teams
  end

  def name
    @teams.first.name
  end

  def team_competition_name
    @teams.first.team_competition.name
  end

  def team_competition_names
    @teams.map {|team| team.team_competition.name}.uniq.join(', ')
  end

  def points
    total_points @cup_team_competition.cup.top_competitions, @cup_team_competition.cup.include_always_last_race?
  end

  def points!
    total_points 1, false
  end

  def team_for_race(race)
    @teams.select { |team| team.race == race }.first
  end

  def min_points_to_emphasize(race_count, top_competitions)
    return nil unless race_count > top_competitions
    points = @teams.map { |team| team.total_score }
    sorted_points = points.filter {|p| !p.nil?}.sort {|a, b| b <=> a}
    sorted_points[top_competitions - 1]
  end

  def self.name(team)
    team.name.strip.downcase
  end

  private

  def points_with_last_race_info_array
    @points_array_with_last_race_info ||= @teams.map { |team| { points: team.total_score, last_cup_race: team.team_competition.last_cup_race } }
  end

  def top_competitions
    @cup_team_competition.cup.top_competitions
  end
end
