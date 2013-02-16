# encoding: UTF-8
require 'model_value_comparator'

class Competitor < ActiveRecord::Base
  include ModelValueComparator
  
  DNS = 'DNS' # did not start
  DNF = 'DNF' # did not finish
  MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE = 100
  
  SORT_BY_POINTS = 0
  SORT_BY_TIME = 1
  SORT_BY_SHOTS = 2
  SORT_BY_ESTIMATES = 3

  belongs_to :club
  belongs_to :series, :counter_cache => true
  belongs_to :age_group
  has_many :shots, :order => 'value desc', :dependent => :destroy

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
  validate :arrival_not_before_start_time
  validate :only_one_shot_input_method_used
  validate :max_ten_shots
  validate :check_no_result_reason
  validate :check_if_series_has_start_list
  validate :unique_number
  validate :unique_name
  validate :concurrent_changes, :on => :update

  after_create :set_correct_estimates
  after_save :update_series_start_time_and_number

  attr_accessor :club_name, :age_group_name, :old_values
  
  def race
    series.race
  end

  def shot_values
    values = shots.collect do |s|
      s.value
    end
    (10 - values.length).times do
      values << nil
    end
    values.sort do |a,b|
      b.to_i <=> a.to_i
    end
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
    return nil if start_time.nil? or arrival_time.nil?
    arrival_time - start_time
  end

  def comparison_time_in_seconds(all_competitors)
    series.comparison_time_in_seconds(age_group, all_competitors)
  end

  def shot_points
    sum = shots_sum
    return nil if sum.nil?
    6 * sum
  end

  def estimate_diff1_m
    return nil unless estimate1 and correct_estimate1
    estimate1 - correct_estimate1
  end

  def estimate_diff2_m
    return nil unless estimate2 and correct_estimate2
    estimate2 - correct_estimate2
  end

  def estimate_diff3_m
    return nil unless estimate3 and correct_estimate3
    estimate3 - correct_estimate3
  end

  def estimate_diff4_m
    return nil unless estimate4 and correct_estimate4
    estimate4 - correct_estimate4
  end

  def estimate_points
    return nil if estimate1.nil? or estimate2.nil? or
      correct_estimate1.nil? or correct_estimate2.nil?
    return nil if series.estimates == 4 and
      (estimate3.nil? or estimate4.nil? or
        correct_estimate3.nil? or correct_estimate4.nil?)
    points = max_estimate_points - 2 * (correct_estimate1 - estimate1).abs -
      2 * (correct_estimate2 - estimate2).abs
    if series.estimates == 4
      points = points - 2 * (correct_estimate3 - estimate3).abs -
        2 * (correct_estimate4 - estimate4).abs
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
    own_time = time_in_seconds
    return nil if own_time.nil?
    best_time = comparison_time_in_seconds(all_competitors)
    return nil if best_time.nil?
    if own_time < best_time
      if self.unofficial
        return 300
      elsif no_result_reason
        return nil
      else
        raise "Competitor time better than the best time and no DNS/DNF/unofficial!"
      end
    end
    points = 300 - (round_seconds(own_time) - round_seconds(best_time)) / 10
    return points.to_i if points >= 0
    0
  end

  def points(all_competitors=false)
    sp = shot_points
    return nil if sp.nil?
    ep = estimate_points
    return nil if ep.nil?
    tp = time_points(all_competitors)
    return nil unless tp or series.time_points_type == Series::TIME_POINTS_TYPE_NONE
    sp + ep + tp.to_i
  end

  def points!(all_competitors=false)
    shot_points.to_i + estimate_points.to_i + time_points(all_competitors).to_i
  end
  
  def relative_points(all_competitors=false)
    return -2 if no_result_reason == DNS
    return -1 if no_result_reason == DNF
    1000*points(all_competitors).to_i + 100*points!(all_competitors).to_i + 10*shot_points.to_i + time_points(all_competitors).to_i
  end

  def finished?
    no_result_reason or
      (start_time and (arrival_time or series.time_points_type != Series::TIME_POINTS_TYPE_NORMAL) and
        shots_sum and estimate1 and estimate2 and
        (series.estimates == 2 or (estimate3 and estimate4)))
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

  def self.sort_competitors(competitors, all_competitors, sort_by=SORT_BY_POINTS)
    if sort_by == SORT_BY_TIME
      sort_competitors_by_time competitors, all_competitors
    elsif sort_by == SORT_BY_SHOTS
      sort_competitors_by_shots competitors, all_competitors 
    elsif sort_by == SORT_BY_ESTIMATES
      sort_competitors_by_estimates competitors, all_competitors
    else
      sort_competitors_by_points competitors, all_competitors
    end
  end

  def self.sort_competitors_by_time(competitors, all_competitors)
    competitors.sort do |a, b|
      [a.no_result_reason.to_s, a.time_in_seconds.to_i,
        ((!all_competitors and a.unofficial) ? 1 : 0),
        b.points(all_competitors).to_i, b.points!(all_competitors).to_i,
        b.shot_points.to_i] <=>
      [b.no_result_reason.to_s, b.time_in_seconds.to_i,
        ((!all_competitors and b.unofficial) ? 1 : 0),
        a.points(all_competitors).to_i, a.points!(all_competitors).to_i,
        a.shot_points.to_i]
    end
  end
    
  def self.sort_competitors_by_shots(competitors, all_competitors)
    competitors.sort do |a, b|
      [a.no_result_reason.to_s, b.shot_points.to_i,
        ((!all_competitors and a.unofficial) ? 1 : 0),
        b.points(all_competitors).to_i, b.points!(all_competitors).to_i,
        a.time_in_seconds.to_i] <=>
      [b.no_result_reason.to_s, a.shot_points.to_i,
        ((!all_competitors and b.unofficial) ? 1 : 0),
        a.points(all_competitors).to_i, a.points!(all_competitors).to_i,
        b.time_in_seconds.to_i]
    end
  end
  
  def self.sort_competitors_by_estimates(competitors, all_competitors)
    competitors.sort do |a, b|
      [a.no_result_reason.to_s, b.estimate_points.to_i,
        ((!all_competitors and a.unofficial) ? 1 : 0),
        b.points(all_competitors).to_i, b.points!(all_competitors).to_i,
        b.shot_points.to_i, a.time_in_seconds.to_i] <=>
      [b.no_result_reason.to_s, a.estimate_points.to_i,
        ((!all_competitors and b.unofficial) ? 1 : 0),
        a.points(all_competitors).to_i, a.points!(all_competitors).to_i,
        a.shot_points.to_i, b.time_in_seconds.to_i]
    end
  end

  def self.sort_competitors_by_points(competitors, all_competitors)
    competitors.sort do |a, b|
      [a.no_result_reason.to_s, ((!all_competitors and a.unofficial) ? 1 : 0),
        b.points(all_competitors).to_i, b.points!(all_competitors).to_i,
        b.shot_points.to_i, a.time_in_seconds.to_i] <=>
      [b.no_result_reason.to_s, ((!all_competitors and b.unofficial) ? 1 : 0),
        a.points(all_competitors).to_i, a.points!(all_competitors).to_i,
        a.shot_points.to_i, b.time_in_seconds.to_i]
    end
  end
  
  def self.free_offline_competitors_left
    raise "Method available only in offline mode" if Mode.online?
    left = MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE - count
    left = 0 if left < 0
    left
  end

  def national_record_reached?
    series.national_record and points.to_i == series.national_record.to_i
  end

  def national_record_passed?
    series.national_record and points.to_i > series.national_record.to_i
  end

  private
  def arrival_not_before_start_time
    return if start_time.nil? and arrival_time.nil?
    if start_time.nil?
      errors.add(:base,
        'Kilpailijalla ei voi olla saapumisaikaa, jos hänellä ei ole lähtöaikaa')
      return
    end
    if arrival_time and start_time >= arrival_time
      errors.add(:arrival_time, "pitää olla lähtöajan jälkeen")
    end
  end

  def only_one_shot_input_method_used
    if shots_total_input
      shots.each do |s|
        if s.value
          errors.add(:base,
            "Ammuntatulokset voi syöttää vain summana tai yksittäisinä laukauksina")
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
    unless [nil, DNS, DNF].include?(no_result_reason)
      errors.add(:no_result_reason,
        "Tuntematon syy tuloksen puuttumiselle: '#{no_result_reason}'")
    end
  end

  def check_if_series_has_start_list
    if series and series.has_start_list?
      errors.add(:number, 'on pakollinen, kun sarjan lähtölista on jo luotu') unless number
      errors.add(:start_time,
        'on pakollinen, kun sarjan lähtölista on jo luotu') unless start_time
    end
  end
  
  def unique_number
    if series and number
      condition = "number = #{number}"
      condition << " and competitors.id <> #{id}" if id
      errors.add(:number, 'on varattu') if series.race.competitors.where(condition).length > 0
    end
  end
  
  def unique_name
    return unless series
    condition = "first_name=? and last_name=?"
    condition << " and id<>#{id}" if id
    if series.competitors.where(condition, first_name, last_name).length > 0
      errors.add(:base, 'Tässä sarjassa on jo saman niminen kilpailija')
    end
  end
  
  def concurrent_changes
    unless values_equal?
      msg = 'Tälle kilpailijalle on syötetty samanaikaisesti toinen tulos. Lataa sivu uudestaan ja yritä tallentamista sen jälkeen'
      errors.add(:base, msg)
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
  
  def update_series_start_time_and_number
    return unless start_time and number
    return if series.start_time or series.first_number
    series.start_time = start_time
    series.first_number = number
    series.save!
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

  def round_seconds(seconds)
    # round down to closest 10 seconds, e.g. 34:49 => 34:40
    seconds.to_i / 10 * 10
  end
end
