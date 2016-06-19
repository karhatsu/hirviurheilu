class TeamCompetition < ActiveRecord::Base
  belongs_to :race
  has_and_belongs_to_many :series, :join_table => 'team_competition_series'
  has_and_belongs_to_many :age_groups, :join_table => 'team_competition_age_groups'

  validates :name, :presence => true
  validates :team_competitor_count, :numericality => { :only_integer => true,
    :greater_than => 1 }

  attr_accessor :temp_series_names, :temp_age_groups_names

  def cache_key
    "#{super}-#{race.updated_at.utc.to_s(:nsec)}-#{race.series.maximum(:updated_at).try(:utc).try(:to_s, :nsec)}"
  end

  def series_names
    (series.map &:name).join(',')
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
    competitors = []
    series.each do |s|
      competitors += s.competitors.includes([:series, :club, :age_group, :shots])
    end
    age_groups.each do |ag|
      competitors += ag.competitors.where(['series_id NOT IN (?)', (series.map &:id)]).
        includes([:series, :club, :age_group, :shots])
    end
    results_for_competitors competitors
  end

  def results_for_competitors(competitors)
    teams_hash = map_sorted_competitors_by_teams competitors
    team_results_hash = create_team_results_hash teams_hash
    sorted_teams = sorted_teams_from_team_results_hash(team_results_hash)
    remove_teams_without_enough_competitors(sorted_teams) if race.finished?
    sorted_teams
  end

  private
  def map_sorted_competitors_by_teams(competitors)
    teams = Hash.new
    Competitor.sort_competitors(competitors, false).each do |competitor|
      break if competitor.points.nil? || competitor.unofficial
      team_name = resolve_team_name competitor
      next unless team_name
      teams[team_name] ||= []
      next if teams[team_name].length >= team_competitor_count
      teams[team_name] << competitor
    end
    teams
  end

  def create_team_results_hash(teams_hash)
    team_results_hash = Hash.new
    teams_hash.each do |team_name, competitors|
      team_hash = { club: team_name, points: 0, best_points: 0, best_shot_points: 0, fastest_time: 9999999, competitors: [] }
      competitors.each do |competitor|
        add_competitor_to_team_hash team_hash, competitor
      end
      team_results_hash[team_name] = team_hash
    end
    team_results_hash
  end

  def add_competitor_to_team_hash(team_hash, competitor)
    competitor_points = competitor.points.to_i
    competitor_shot_points = competitor.shot_points.to_i
    competitor_time = competitor.time_in_seconds
    team_hash[:competitors] << competitor
    team_hash[:points] += competitor_points
    team_hash[:best_points] = competitor_points if competitor_points > team_hash[:best_points]
    team_hash[:best_shot_points] = competitor_shot_points if competitor_shot_points > team_hash[:best_shot_points]
    team_hash[:fastest_time] = competitor_time if competitor_time && competitor_time < team_hash[:fastest_time]
  end

  def sorted_teams_from_team_results_hash(hash)
    hash.values.sort do |a, b|
      [b[:points], b[:best_points], b[:best_shot_points], a[:fastest_time]] <=>
        [a[:points], a[:best_points], a[:best_shot_points], b[:fastest_time]]
    end
  end

  def remove_teams_without_enough_competitors(sorted_teams)
    sorted_teams.delete_if { |club| club[:competitors].length < team_competitor_count }
  end
  
  def resolve_team_name(competitor)
    if use_team_name
      return nil if competitor.team_name.blank?
      return competitor.team_name
    end
    competitor.club.display_name
  end
end
