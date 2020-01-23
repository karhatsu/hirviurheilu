class TeamCompetition < ApplicationRecord
  belongs_to :race
  has_and_belongs_to_many :series, :join_table => 'team_competition_series'
  has_and_belongs_to_many :age_groups, :join_table => 'team_competition_age_groups'

  validates :name, :presence => true
  validates :team_competitor_count, :numericality => { :only_integer => true,
    :greater_than => 1 }

  attr_accessor :temp_series_names, :temp_age_groups_names

  delegate :sport, to: :race

  def cache_key
    "#{super}-#{race.updated_at.utc.to_s(:usec)}-#{race.series.maximum(:updated_at).try(:utc).try(:to_s, :usec)}"
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
    competitors = find_competitors
    results_for_competitors competitors
  end

  def results_for_competitors(competitors)
    official_competitors = competitors.select { |c| !c.unofficial? }
    teams_hash = map_sorted_competitors_by_teams official_competitors
    sorted_teams = sort_teams teams_hash
    remove_teams_without_enough_competitors(sorted_teams) if race.finished?
    sorted_teams
  end

  private
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

  def map_sorted_competitors_by_teams(competitors)
    competitor_counter_by_team = Hash.new
    teams = Hash.new
    Competitor.sort_team_competitors(sport, competitors).each do |competitor|
      break if competitor.team_competition_points(sport).nil?
      base_team_name = resolve_team_name competitor
      next unless base_team_name
      competitor_counter_by_team[base_team_name] ||= 0
      team_name = team_name_with_number base_team_name, competitor_counter_by_team[base_team_name]
      next unless team_name
      teams[team_name] ||= Team.new(sport, team_name)
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

  def sort_teams(hash)
    if sport.only_shooting?
      hash.values.sort do |a, b|
        [b.total_score, b.best_competitor_score, b.hits] + b.shot_counts <=>
            [a.total_score, a.best_competitor_score, a.hits] + a.shot_counts
      end
    else
      hash.values.sort do |a, b|
        [b.total_score, b.best_competitor_score, b.best_shooting_score, a.fastest_time] <=>
          [a.total_score, a.best_competitor_score, a.best_shooting_score, b.fastest_time]
      end
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
