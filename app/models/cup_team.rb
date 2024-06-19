class CupTeam
  include CupScore

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

  def score
    total_score @cup_team_competition.cup.top_competitions, @cup_team_competition.cup.include_always_last_race?
  end

  def score!
    total_score 1, false
  end

  def team_for_race(race)
    @teams.select { |team| team.race == race }.first
  end

  def min_score_to_emphasize(race_count, top_competitions)
    return nil unless race_count > top_competitions
    scores = @teams.map { |team| team.total_score }
    sorted_scores = scores.filter {|p| !p.nil?}.sort {|a, b| b <=> a}
    sorted_scores[top_competitions - 1]
  end

  def self.name(team)
    team.name.strip.downcase
  end

  private

  def score_with_last_race_info_array
    @score_array_with_last_race_info ||= @teams.map { |team| { score: team.total_score, last_cup_race: team.team_competition.last_cup_race } }
  end

  def top_competitions
    @cup_team_competition.cup.top_competitions
  end
end
