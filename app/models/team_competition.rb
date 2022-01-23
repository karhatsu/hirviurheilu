class TeamCompetition < ApplicationRecord
  belongs_to :race
  has_and_belongs_to_many :series, :join_table => 'team_competition_series'
  has_and_belongs_to_many :age_groups, :join_table => 'team_competition_age_groups'

  validates :name, :presence => true
  validates :team_competitor_count, numericality: { only_integer: true, greater_than: 1 }
  validates :national_record, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  validate :extra_shots_values

  attr_accessor :temp_series_names, :temp_age_groups_names

  delegate :sport, to: :race

  def cache_key
    "#{super}-#{race.updated_at.utc.to_formatted_s(:usec)}-#{race.series.maximum(:updated_at).try(:utc).try(:to_formatted_s, :usec)}"
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

  def rifle_results
    raise "Cannot calculate rifle results for #{sport.name}" unless sport.european?
    results_for_competitors find_competitors, true
  end

  def results_for_competitors(competitors, rifle=false)
    official_competitors = competitors.select { |c| !c.unofficial? }
    teams_hash = map_sorted_competitors_by_teams official_competitors, rifle
    sorted_teams = sort_teams teams_hash, rifle
    remove_teams_without_enough_competitors(sorted_teams) if race.finished?
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
      break if competitor.team_competition_points(sport, rifle).nil?
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
    if rifle
      hash.values.sort do |a, b|
        [b.total_score] + b.european_rifle_results + [b.hits] + b.shot_counts <=>
            [a.total_score] + a.european_rifle_results + [a.hits] + a.shot_counts
      end
    elsif sport.nordic?
      hash.values.sort do |a, b|
        [b.total_score, b.extra_score, b.best_competitor_score] <=> [a.total_score, a.extra_score, a.best_competitor_score]
      end
    elsif sport.european?
      hash.values.sort do |a, b|
        [b.total_score] + b.european_total_results <=> [a.total_score] + a.european_total_results
      end
    elsif sport.shooting?
      hash.values.sort do |a, b|
        [b.total_score] + b.extra_shots + [b.best_competitor_score, b.hits] + b.shot_counts <=>
            [a.total_score] + a.extra_shots + [a.best_competitor_score, a.hits] + a.shot_counts
      end
    else
      hash.values.sort do |a, b|
        [b.total_score, b.best_competitor_score, b.best_shooting_score, a.fastest_time || 9999999] <=>
          [a.total_score, a.best_competitor_score, a.best_shooting_score, b.fastest_time || 9999999]
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
