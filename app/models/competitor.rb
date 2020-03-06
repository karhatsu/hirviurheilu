require 'model_value_comparator'

class Competitor < ApplicationRecord
  include ModelValueComparator
  include StartDateTime
  include Shots
  include CompetitorResults

  DNS = 'DNS' # did not start
  DNF = 'DNF' # did not finish
  DQ = 'DQ' # disqualified

  SORT_BY_POINTS = 0
  SORT_BY_TIME = 1
  SORT_BY_SHOTS = 2
  SORT_BY_ESTIMATES = 3

  MAX_START_TIME = Time.utc 2000, 1, 1, 6, 59, 59

  belongs_to :club
  belongs_to :series, counter_cache: true, touch: true
  belongs_to :age_group
  belongs_to :batch

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :number,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true }
  shooting_score_input_validations = { numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true } }
  validates :shooting_score_input, shooting_score_input_validations
  validates :qualification_round_shooting_score_input, shooting_score_input_validations
  validates :final_round_shooting_score_input, shooting_score_input_validations
  estimate_validations = {allow_nil: true, numericality: { only_integer: true, greater_than: 0 }}
  validates :estimate1, estimate_validations
  validates :estimate2, estimate_validations
  validates :estimate3, estimate_validations
  validates :estimate4, estimate_validations
  validates :correct_estimate1, estimate_validations
  validates :correct_estimate2, estimate_validations
  validates :correct_estimate3, estimate_validations
  validates :correct_estimate4, estimate_validations
  validates :shooting_overtime_min, numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil: true }
  validates :track_place, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  validate :start_time_max
  validate :times_in_correct_order
  validate :only_one_shot_input_method_used
  validate :shots_array_values
  validate :extra_shots_array_values
  validate :check_no_result_reason
  validate :check_if_series_has_start_list
  validate :unique_number
  validate :unique_name
  validate :concurrent_changes, :on => :update
  validate :track_place_fitting

  before_save :set_has_result, :reset_age_group, :set_shooting_overtime_min, :convert_string_shots, :convert_string_extra_shots

  after_create :set_correct_estimates
  after_save :update_series_start_time_and_number
  after_update :update_series_competitors_counter_cache

  attr_accessor :club_name, :age_group_name, :old_values

  def race
    series&.race
  end

  def sport
    race&.sport
  end

  def series_name
    series&.name
  end

  def time_in_seconds
    return nil if start_time.nil? || arrival_time.nil?
    arrival_time.to_i - start_time.to_i
  end

  def comparison_time_in_seconds(unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)
    comparison_time = series.comparison_time_in_seconds(age_group, unofficials)
    if comparison_time.nil? && unofficial? && [Series::UNOFFICIALS_EXCLUDED, Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME].include?(unofficials)
      comparison_time = series.comparison_time_in_seconds(age_group, Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME)
    end
    comparison_time
  end

  def shooting_points
    sum = shooting_score or return nil
    6 * (sum + shooting_overtime_penalty.to_i)
  end

  def shooting_overtime_penalty
    return nil unless series.walking_series?
    -3 * shooting_overtime_min if shooting_overtime_min.to_i > 0
  end

  def shooting_time_seconds
    return nil unless shooting_start_time && shooting_finish_time
    shooting_finish_time - shooting_start_time
  end

  def estimate_diff1_m
    return nil unless estimate1 && correct_estimate1
    estimate1 - correct_estimate1
  end

  def estimate_diff2_m
    return nil unless estimate2 && correct_estimate2
    estimate2 - correct_estimate2
  end

  def estimate_diff3_m
    return nil unless estimate3 && correct_estimate3
    estimate3 - correct_estimate3
  end

  def estimate_diff4_m
    return nil unless estimate4 && correct_estimate4
    estimate4 - correct_estimate4
  end

  def estimate_points
    return nil unless has_estimates? && has_correct_estimates?
    error_meters = (correct_estimate1 - estimate1).abs + (correct_estimate2 - estimate2).abs
    if series.estimates == 4
      error_meters = error_meters + (correct_estimate3 - estimate3).abs + (correct_estimate4 - estimate4).abs
    end
    if series.points_method == Series::POINTS_METHOD_NO_TIME_2_ESTIMATES
      points = 600 - 4 * error_meters
    elsif series.points_method == Series::POINTS_METHOD_NO_TIME_4_ESTIMATES
      points = 600 - 2 * error_meters
    elsif series.points_method == Series::POINTS_METHOD_TIME_4_ESTIMATES
      points = 300 - 1 * error_meters
    else
      points = 300 - 2 * error_meters
    end
    return points if points >= 0
    0
  end

  def has_estimates?
    return false if estimate1.nil? || estimate2.nil?
    return false if series.estimates == 4 && (estimate3.nil? || estimate4.nil?)
    true
  end

  def has_correct_estimates?
    return false if correct_estimate1.nil? || correct_estimate2.nil?
    return false if series.estimates == 4 && (correct_estimate3.nil? || correct_estimate4.nil?)
    true
  end

  def time_points(unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)
    return nil if series.points_method == Series::POINTS_METHOD_NO_TIME_2_ESTIMATES || series.points_method == Series::POINTS_METHOD_NO_TIME_4_ESTIMATES
    return 300 if series.points_method == Series::POINTS_METHOD_300_TIME_2_ESTIMATES
    own_time = time_in_seconds or return nil
    best_time = comparison_time_in_seconds(unofficials) or return nil
    return resolve_time_points_for_invalid_own_time if own_time < best_time
    calculate_time_points own_time, best_time
  end

  def points(unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)
    return nil if no_result_reason
    return shooting_score if sport.only_shooting?
    shooting_points.to_i + estimate_points.to_i + time_points(unofficials).to_i
  end

  def team_competition_points(sport)
    return qualification_round_score if sport.only_shooting?
    points
  end

  def finished?
    return true if no_result_reason
    if sport.only_shooting?
      return true if qualification_round_shooting_score_input
      shots && (shots.length == 10 || shots.length >= 20)
    else
      (start_time && (arrival_time || series.walking_series?) && shooting_score && estimate1 && estimate2 &&
        (series.estimates == 2 || (estimate3 && estimate4)))
    end
  end

  def next_competitor
    previous_or_next_competitor false
  end

  def previous_competitor
    previous_or_next_competitor true
  end

  def reset_correct_estimates
    self.correct_estimate1 = nil
    self.correct_estimate2 = nil
    self.correct_estimate3 = nil
    self.correct_estimate4 = nil
  end

  def start_datetime
    start_date_time race, series.start_day, start_time
  end

  def real_time(attribute)
    start_date_time race, series.start_day, self[attribute]
  end

  def self.sort_competitors(competitors)
    return sort_shooting_race_competitors(competitors) if competitors.length && competitors[0].sport.only_shooting?
    sort_three_sports_competitors competitors
  end

  def self.sort_team_competitors(sport, competitors)
    return sort_three_sports_competitors competitors unless sport.only_shooting?
    competitors.sort do |a, b|
      b.shooting_race_qualification_results <=> a.shooting_race_qualification_results
    end
  end

  def self.sort_by_qualification_round(sport, competitors)
    raise "Sport #{sport.name} does not have qualification round" unless sport.qualification_round
    competitors.sort do |a, b|
      b.shooting_race_qualification_results <=> a.shooting_race_qualification_results
    end
  end

  def self.sort_three_sports_competitors(competitors, unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by=SORT_BY_POINTS)
    competitors.sort do |a, b|
      b.three_sports_race_results(unofficials, sort_by) + [a.number.to_i] <=>
          a.three_sports_race_results(unofficials, sort_by) + [b.number.to_i]
    end
  end

  def self.sort_shooting_race_competitors(competitors)
    competitors.sort do |a, b|
      [b.shooting_race_results(competitors), a.number.to_i] <=> [a.shooting_race_results(competitors), b.number.to_i]
    end
  end

  def national_record_reached?
    series.national_record && points.to_i == series.national_record.to_i
  end

  def national_record_passed?
    series.national_record && points.to_i > series.national_record.to_i
  end

  def correct_distances
    [correct_estimate1, correct_estimate2, correct_estimate3, correct_estimate4].select {|d| !d.blank?}
  end

  def short_time(attribute)
    return nil unless self[attribute]
    self[attribute].strftime '%H:%M:%S'
  end

  def self.invalid_shot?(shot, max_value)
    shot.to_i < 0 || shot.to_i > max_value || shot.to_i.to_s != shot.to_s
  end

  private

  def start_time_max
    errors.add :start_time, :too_big if start_time && start_time > MAX_START_TIME
  end

  def times_in_correct_order
    return if start_time.nil? && shooting_start_time.nil? && shooting_finish_time.nil? && arrival_time.nil?
    unless start_time
      validate_against_missing_start_time :shooting_start_time
      validate_against_missing_start_time :shooting_finish_time
      validate_against_missing_start_time :arrival_time
    end

    validate_times_order :start_time, :shooting_start_time

    validate_times_order :start_time, :shooting_finish_time
    validate_times_order :shooting_start_time, :shooting_finish_time

    validate_times_order :start_time, :arrival_time
    validate_times_order :shooting_start_time, :arrival_time
    validate_times_order :shooting_finish_time, :arrival_time
  end

  def validate_against_missing_start_time(time_field)
    errors.add time_field, :cannot_have_without_start_time if self[time_field]
  end

  def validate_times_order(first_time_field, second_time_field)
    second_time = self[second_time_field]
    return unless second_time
    first_time = self[first_time_field]
    errors.add second_time_field, "must_be_after_#{first_time_field}".to_sym if first_time && first_time >= second_time
  end

  def only_one_shot_input_method_used
    if shots && (shooting_score_input || qualification_round_shooting_score_input || final_round_shooting_score_input)
      errors.add(:base, :shooting_result_either_sum_or_by_shots)
    end
  end

  def shots_array_values
    return unless shots
    max_value = sport&.max_shot || 10
    errors.add(:shots, :too_many) if sport && shots.length > sport.max_shots_count
    errors.add(:shots, :invalid_value) if shots.any? { |shot| Competitor.invalid_shot? shot, max_value }
  end

  def extra_shots_array_values
    return unless extra_shots
    max_value = sport&.max_shot || 10
    errors.add(:extra_shots, :invalid_value) if extra_shots.any? { |shot| Competitor.invalid_shot? shot, max_value }
  end

  def check_no_result_reason
    self.no_result_reason = nil if no_result_reason == ''
    unless [nil, DNS, DNF, DQ].include?(no_result_reason)
      errors.add(:no_result_reason,
        "Tuntematon syy tuloksen puuttumiselle: '#{no_result_reason}'")
    end
  end

  def check_if_series_has_start_list
    if series && series.has_start_list?
      errors.add(:number, :required_when_start_list_created) unless number
      errors.add(:start_time, :required_when_start_list_created) unless start_time
    end
  end

  def unique_number
    if series && number
      condition = "number = #{number}"
      condition << " and competitors.id <> #{id}" if id
      errors.add(:number, :is_in_use) if series.race.competitors.where(condition).length > 0
    end
  end

  def unique_name
    return unless series
    condition = "first_name=? and last_name=?"
    condition << " and id<>#{id}" if id
    if series.competitors.where(condition, first_name, last_name).length > 0
      errors.add(:base, :another_competitor_with_same_name_in_series)
    end
  end

  def concurrent_changes
    unless values_equal?
      msg = 'Tälle kilpailijalle on syötetty samanaikaisesti toinen tulos. Lataa sivu uudestaan ja yritä tallentamista sen jälkeen'
      errors.add(:base, msg)
    end
  end

  def track_place_fitting
    shooting_place_count = race&.competitors_per_batch
    errors.add :track_place, :too_big if shooting_place_count && track_place && track_place > shooting_place_count
  end

  def set_has_result
    self.has_result = true if arrival_time || estimate1 || shooting_score_input || qualification_round_shooting_score_input || final_round_shooting_score_input || shots
  end

  def reset_age_group
    self.age_group_id = nil if series.age_groups.empty?
  end

  def set_shooting_overtime_min
    return unless shooting_start_time && shooting_finish_time
    shooting_overtime_seconds = shooting_finish_time - shooting_start_time - 7 * 60
    if shooting_overtime_seconds > 0
      self.shooting_overtime_min = (shooting_overtime_seconds / 60).to_i + 1
    else
      self.shooting_overtime_min = 0
    end
  end

  def set_correct_estimates
    if number
      correct_estimate = CorrectEstimate.for_number_in_race(number, series.race)
      if correct_estimate
        self.correct_estimate1 = correct_estimate.distance1
        self.correct_estimate2 = correct_estimate.distance2
        self.correct_estimate3 = correct_estimate.distance3
        self.correct_estimate4 = correct_estimate.distance4
        save!
      end
    end
  end

  def convert_string_shots
    return unless shots
    self.shots = shots.map {|shot| shot.to_i}
  end

  def convert_string_extra_shots
    return unless extra_shots
    self.extra_shots = extra_shots.map {|shot| shot.to_i}
  end

  def update_series_start_time_and_number
    return unless start_time && number
    series.update_start_time_and_number
  end

  def update_series_competitors_counter_cache
    if saved_change_to_series_id
      Series.reset_counters series_id, :competitors
      Series.reset_counters series_id_before_last_save, :competitors if series_id_before_last_save
    end
  end

  def previous_or_next_competitor(previous)
    comparator = previous ? '<' : '>'
    sort_order = previous ? 'DESC' : 'ASC'
    compare_column = number ? 'number' : 'id'
    compare_value = number ? number : id
    # prev/next by number or id:
    competitor = Competitor.where(["series_id=? and #{compare_column}#{comparator}?",
        series.id, compare_value]).order("#{compare_column} #{sort_order}").first
    return competitor if competitor
    # when we are at the beginning/end of the list:
    Competitor.where("series_id=? and #{compare_column} is not null", series.id).
      order("#{compare_column} #{sort_order}").first
  end

  def resolve_time_points_for_invalid_own_time
    if unofficial?
      300
    elsif no_result_reason
      nil
    else
      raise 'Competitor time better than the best time and no DNS/DNF/DQ/unofficial!'
    end
  end

  def calculate_time_points(own_time, best_time)
    seconds_diff = round_seconds(own_time) - round_seconds(best_time)
    if seconds_diff <= 5 * 60 || race_year < 2017
      points = 300 - seconds_diff / 10
    else
      # 0-5 min: -1 point / every 10 seconds, 5- min: -1 point / every 20 seconds
      points = 300 - 5 * 6 - (seconds_diff - 5 * 60) / 20
    end
    return points.to_i if points >= 0
    0
  end

  def round_seconds(seconds)
    # round down to closest 10 seconds, e.g. 34:49 => 34:40
    seconds.to_i / 10 * 10
  end

  def race_year
    race.start_date.year
  end
end
