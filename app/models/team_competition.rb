class TeamCompetition < ApplicationRecord
  include CompetitorPosition

  belongs_to :race
  has_and_belongs_to_many :series, :join_table => 'team_competition_series'
  has_and_belongs_to_many :age_groups, :join_table => 'team_competition_age_groups'

  validates :name, :presence => true
  validates :team_competitor_count, numericality: { only_integer: true, greater_than: 1 }
  validates :national_record, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  validate :extra_shots_values

  attr_accessor :temp_series_names, :temp_age_groups_names, :last_cup_race

  delegate :sport, to: :race

  def cache_key
    "#{super}-#{race.updated_at.utc.to_formatted_s(:usec)}-#{race.series.maximum(:updated_at).try(:utc).try(:to_formatted_s, :usec)}"
  end

  def series_names
    (series.order(:name).map &:name).join(',')
  end

  def attach_series_by_names(names)
    names.split(',').each do |name|
      series << race.series.find_by_name(name)
    end
  end

  def age_groups_names
    (age_groups.map &:name).join(',')
  end

  def attach_age_groups_by_names(names)
    names.split(',').each do |name|
      age_groups << race.age_groups.find_by_name(name)
    end
  end

  def started?
    series.each do |s|
      return true if s.started?
    end
    false
  end

  def results
    competitors = find_competitors
    sorted_teams = results_for_competitors competitors
    add_position_for_competitors(sorted_teams, sport.european?) do |team|
      team_results team, false
    end
  end

  def rifle_results
    raise "Cannot calculate rifle results for #{sport.name}" unless sport.european?
    sorted_teams = results_for_competitors find_competitors, true
    add_position_for_competitors(sorted_teams, true) do |team|
      team_results team, true
    end
  end

  def results_for_competitors(competitors, rifle=false)
    official_competitors = competitors.select { |c| !c.unofficial? }
    teams_hash = map_sorted_competitors_by_teams official_competitors, rifle
    sorted_teams = sort_teams teams_hash, rifle
    remove_teams_without_enough_competitors(sorted_teams) if race.finished? && !show_partial_teams
    sorted_teams
  end

  def has_extra_score?
    max_extra_shots > 0 || (extra_shots && extra_shots.length > 0)
  end

  def max_extra_shots
    return 0 unless extra_shots
    extra_shots.map {|x| [x['shots1']&.length, x['shots2']&.length].map(&:to_i)}.flatten.max || 0
  end

  private

  def extra_shots_values
    return unless extra_shots
    extra_shots.each do |x|
      errors.add(:extra_shots, :invalid_shots) and break unless valid_shots(x['shots1']) && valid_shots(x['shots2'])
    end
  end

  def valid_shots(shots)
    shots.nil? || shots.all? {|shot| shot == 0 || shot == 1}
  end

  def find_competitors
    competitors = []
    includes = [:series, :club, :age_group]
    series.each do |s|
      competitors += s.competitors.includes(includes)
    end
    age_groups.each do |ag|
      competitors += ag.competitors.where(['series_id NOT IN (?)', (series.map &:id)]).includes(includes)
    end
    competitors.sort {|a, b| a.id <=> b.id} # sorting for the unit test
  end

  def map_sorted_competitors_by_teams(competitors, rifle)
    competitor_counter_by_team = Hash.new
    teams = Hash.new
    Competitor.sort_team_competitors(sport, competitors, rifle).each do |competitor|
      break if competitor.team_competition_score(sport, rifle).nil?
      base_team_name = resolve_team_name competitor
      next unless base_team_name
      competitor_counter_by_team[base_team_name] ||= 0
      team_name = team_name_with_number base_team_name, competitor_counter_by_team[base_team_name]
      next unless team_name
      teams[team_name] ||= Team.new(self, team_name, competitor.club_id, rifle)
      teams[team_name] << competitor
      competitor_counter_by_team[base_team_name] = competitor_counter_by_team[base_team_name] + 1
    end
    teams
  end

  def team_name_with_number(base_team_name, previous_competitors_count)
    team_number = (previous_competitors_count / team_competitor_count) + 1
    return nil if team_number > 1 && !multiple_teams
    return base_team_name if team_number == 1 || !multiple_teams
    "#{base_team_name} #{RomanNumerals.to_roman(team_number)}"
  end

  def sort_teams(hash, rifle)
    hash.values.sort do |a, b|
      team_results(b, rifle) <=> team_results(a, rifle)
    end
  end

  def team_results(team, rifle)
    if rifle
      [team.total_score] + team.european_rifle_secondary_results
    elsif sport.nordic?
      [team.total_score, team.extra_score, team.best_competitor_score]
    elsif sport.european?
      [team.total_score] + team.european_secondary_results
    elsif sport.shooting?
      [team.total_score] + team.extra_shots + [team.best_competitor_score, team.hits] + team.shot_counts
    else
      [team.total_score, team.best_competitor_score, team.best_shooting_score, -(team.fastest_time || 9999999)]
    end
  end

  def remove_teams_without_enough_competitors(sorted_teams)
    sorted_teams.delete_if { |team| team.competitors.length < team_competitor_count }
  end

  def resolve_team_name(competitor)
    if use_team_name
      return nil if competitor.team_name.blank?
      return competitor.team_name
    end
    competitor.club.display_name
  end
end
