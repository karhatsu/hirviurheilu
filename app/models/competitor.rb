require 'model_value_comparator'

class Competitor < ActiveRecord::Base
  include ModelValueComparator
  include StartDateTime
  
  DNS = 'DNS' # did not start
  DNF = 'DNF' # did not finish
  DQ = 'DQ' # disqualified
  MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE = 100
  
  SORT_BY_POINTS = 0
  SORT_BY_TIME = 1
  SORT_BY_SHOTS = 2
  SORT_BY_ESTIMATES = 3

  belongs_to :club
  belongs_to :series, counter_cache: true, touch: true
  belongs_to :age_group
  has_many :shots, -> { order 'value desc' }, :dependent => :destroy

  accepts_nested_attributes_for :shots, :allow_destroy => true

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :number,
    :numericality => { :only_integer => true, :greater_than => 0, :allow_nil => true }
  validates :shots_total_input, :allow_nil => true,
    :numericality => { :only_integer => true,
      :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :estimate1, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :estimate2, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :estimate3, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :estimate4, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :correct_estimate1, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :correct_estimate2, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :correct_estimate3, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :correct_estimate4, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :shooting_overtime_min, numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil: true }
  validate :times_in_correct_order
  validate :only_one_shot_input_method_used
  validate :max_ten_shots
  validate :check_no_result_reason
  validate :check_if_series_has_start_list
  validate :unique_number
  validate :unique_name
  validate :concurrent_changes, :on => :update

  before_save :set_has_result, :reset_age_group

  after_create :set_correct_estimates
  after_save :update_series_start_time_and_number
  after_update :update_series_competitors_counter_cache

  attr_accessor :club_name, :age_group_name, :old_values
  
  def race
    series.race
  end

  def shot_values
    values = shots.collect do |s|
      s.value
    end
    values = values.sort do |a,b|
      b.to_i <=> a.to_i
    end
    (10 - values.length).times do
      values << nil
    end
    values
  end

  def shots_sum
    return @shots_sum if @shots_sum
    if shots_total_input
      @shots_sum = shots_total_input
    elsif shots.empty?
      return nil
    else
      @shots_sum = shots.map(&:value).map(&:to_i).inject(:+)
    end
    @shots_sum
  end

  def time_in_seconds
    return nil if start_time.nil? || arrival_time.nil?
    arrival_time - start_time
  end

  def comparison_time_in_seconds(all_competitors)
    series.comparison_time_in_seconds(age_group, all_competitors)
  end

  def shot_points
    sum = shots_sum or return nil
    6 * sum + shooting_overtime_penalty.to_i
  end

  def shooting_overtime_penalty
    -3 * shooting_overtime_min if shooting_overtime_min.to_i > 0
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
    return nil if estimate1.nil? || estimate2.nil? || correct_estimate1.nil? || correct_estimate2.nil?
    return nil if series.estimates == 4 && (estimate3.nil? || estimate4.nil? || correct_estimate3.nil? || correct_estimate4.nil?)
    points = max_estimate_points - 2 * (correct_estimate1 - estimate1).abs - 2 * (correct_estimate2 - estimate2).abs
    if series.estimates == 4
      points = points - 2 * (correct_estimate3 - estimate3).abs - 2 * (correct_estimate4 - estimate4).abs
    end
    return points if points >= 0
    0
  end

  def max_estimate_points
    series.estimates == 4 ? 600 : 300
  end

  def time_points(all_competitors=false)
    return nil if series.time_points_type == Series::TIME_POINTS_TYPE_NONE
    return 300 if series.time_points_type == Series::TIME_POINTS_TYPE_ALL_300
    own_time = time_in_seconds or return nil
    best_time = comparison_time_in_seconds(all_competitors) or return nil
    return resolve_time_points_for_invalid_own_time if own_time < best_time
    calculate_time_points own_time, best_time
  end

  def points(all_competitors=false)
    return nil if no_result_reason
    shot_points.to_i + estimate_points.to_i + time_points(all_competitors).to_i
  end
  
  def relative_points(all_competitors=false, sort_by=SORT_BY_POINTS)
    return -1000003 if no_result_reason == DQ
    return -1000002 if no_result_reason == DNS
    return -1000001 if no_result_reason == DNF
    if sort_by == SORT_BY_SHOTS
      shot_points.to_i
    elsif sort_by == SORT_BY_ESTIMATES
      estimate_points.to_i
    elsif sort_by == SORT_BY_TIME
      return -time_in_seconds.to_i if time_in_seconds
      -1000000
    else
      relative_points = 100000*points(all_competitors).to_i + 100*shot_points.to_i - time_in_seconds.to_i
      relative_points = relative_points * 10 unless all_competitors || unofficial?
      relative_points
    end
  end

  def relative_shot_points
    shots.inject(0) {|sum, shot| sum = sum + shot.value * shot.value; sum}
  end

  def finished?
    no_result_reason ||
      (start_time && (arrival_time || series.time_points_type != Series::TIME_POINTS_TYPE_NORMAL) &&
        shots_sum && estimate1 && estimate2 &&
        (series.estimates == 2 || (estimate3 && estimate4)))
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

  def self.sort_competitors(competitors, all_competitors, sort_by=SORT_BY_POINTS)
    competitors.sort do |a, b|
      [b.relative_points(all_competitors, sort_by), a.number] <=> [a.relative_points(all_competitors, sort_by), b.number]
    end
  end
  
  def self.free_offline_competitors_left
    raise "Method available only in offline mode" if Mode.online?
    left = MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE - count
    left = 0 if left < 0
    left
  end

  def national_record_reached?
    series.national_record && points.to_i == series.national_record.to_i
  end

  def national_record_passed?
    series.national_record && points.to_i > series.national_record.to_i
  end

  private
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
    if shots_total_input
      shots.each do |s|
        if s.value
          errors.add(:base, :shooting_result_either_sum_or_by_shots)
          return
        end
      end
    end
  end

  def max_ten_shots
    errors.add(:shots, "Laukauksia voi olla enintään 10") if shots.length > 10
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

  def set_has_result
    self.has_result = true if arrival_time || estimate1 || shots_total_input
  end

  def reset_age_group
    self.age_group_id = nil if series.age_groups.empty?
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
  
  def update_series_start_time_and_number
    return unless start_time && number
    series.update_start_time_and_number
  end

  def update_series_competitors_counter_cache
    if series_id_was && series_id_was != series_id
      Series.reset_counters series_id, :competitors
      Series.reset_counters series_id_was, :competitors
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
