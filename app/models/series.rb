require 'time_helper.rb'

class Series < ApplicationRecord
  include TimeHelper
  include StartDateTime
  include ComparisonTime

  TIME_POINTS_TYPE_NORMAL = 0
  TIME_POINTS_TYPE_NONE = 1
  TIME_POINTS_TYPE_ALL_300 = 2

  POINTS_METHOD_TIME_2_ESTIMATES = 0
  POINTS_METHOD_TIME_4_ESTIMATES = 1
  POINTS_METHOD_NO_TIME_4_ESTIMATES = 2
  POINTS_METHOD_300_TIME_2_ESTIMATES = 3
  POINTS_METHOD_NO_TIME_2_ESTIMATES = 4

  UNOFFICIALS_EXCLUDED = 1 # to the bottom in the results, cannot have the best time (until 2017, default)
  UNOFFICIALS_INCLUDED_WITH_BEST_TIME = 2 # normally in the results, can have the best time (until 2017, by selection)
  UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME = 3 # normally in the results, cannot have the best time (since 2018)

  START_LIST_ADDING_ORDER = 0
  START_LIST_RANDOM = 1

  belongs_to :race, :counter_cache => true
  has_many :age_groups, -> { order(:name) }, :dependent => :destroy
  has_many :competitors, -> { order(:number, :id) }, :dependent => :destroy
  has_many :start_list, -> { where('start_time is not null').order(:start_time, :number) }, :class_name => "Competitor", :foreign_key => 'series_id'

  accepts_nested_attributes_for :age_groups, :allow_destroy => true
  accepts_nested_attributes_for :competitors

  before_validation :check_points_method, :strip_series

  validates :name, :presence => true
  #validates :race, :presence => true
  validates :first_number, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :start_day, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validates :national_record, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validates :points_method, inclusion: {in: [POINTS_METHOD_TIME_2_ESTIMATES,
                                             POINTS_METHOD_TIME_4_ESTIMATES,
                                             POINTS_METHOD_NO_TIME_2_ESTIMATES,
                                             POINTS_METHOD_NO_TIME_4_ESTIMATES,
                                             POINTS_METHOD_300_TIME_2_ESTIMATES]}
  validate :start_time_max
  validate :start_day_not_bigger_than_race_days_count

  before_create :set_has_start_list

  after_destroy :touch_race

  attr_accessor :last_cup_race

  delegate :sport, to: :race

  def cache_key
    "#{super}-#{race.updated_at.utc.to_s(:usec)}"
  end

  def points_method=(points_method)
    super points_method
    set_estimates
  end

  def results
    return nordic_race_results if sport.nordic?
    return shooting_race_results if sport.shooting?
    three_sports_results
  end

  def three_sports_results(unofficials=UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by=Competitor::SORT_BY_POINTS)
    Competitor.sort_three_sports_competitors competitors.includes([:club, :age_group, :series]), unofficials, sort_by
  end

  def shooting_race_results
    Competitor.sort_shooting_race_competitors competitors.includes([:club, :age_group, :series])
  end

  def nordic_race_results
    Competitor.sort_nordic_competitors competitors.includes([:club, :age_group, :series])
  end

  def next_start_number
    race.next_start_number
  end

  def next_start_time
    race.next_start_time
  end

  def generate_start_list(order_method)
    return false unless generate_numbers(order_method)
    return false unless generate_start_times
    self.has_start_list = true
    save!
  end

  def generate_start_list!(order_method)
    generate_numbers!(order_method)
    generate_start_times!
    self.has_start_list = true
    save!
  end

  def generate_numbers(order_method)
    return false unless can_generate_numbers?

    c = (order_method.to_i == START_LIST_RANDOM ?
        competitors.shuffle : Competitor.where(:series_id => id).order('id asc'))
    c.each_with_index do |comp, i|
      comp.update_column(:number, first_number + i)
    end

    race.set_correct_estimates_for_competitors
    true
  end

  def generate_numbers!(order_method)
    generate_numbers(order_method) || raise(errors.full_messages.to_s)
  end

  def some_competitor_has_arrival_time?
    competitors.each do |comp|
      return true if comp.arrival_time
    end
    false
  end

  def generate_start_times
    reload
    return false unless can_generate_start_times?

    last_number = competitors.last.number
    batch_size = race.batch_size
    batch_interval = race.batch_interval_seconds - race.start_interval_seconds
    # calculate where last (possibly partial) batch starts
    if batch_size > 0
      last_batch_size = (last_number - first_number + 1) % batch_size
      last_batch_start = first_number +
        ((last_number - first_number + 1) / batch_size).to_i * batch_size
    end
    batch_size = 0 if last_batch_start == first_number

    set_start_times_for_competitors(competitors, batch_size,
      last_batch_start, last_batch_size, batch_interval)
    true
  end

  def generate_start_times!
    generate_start_times || raise(errors.full_messages.to_s)
  end

  def each_competitor_has_number?
    !competitors.where(:number => nil).exists?
  end

  def each_competitor_has_start_time?
    !competitors.where(:start_time => nil).exists?
  end

  def each_competitor_finished?
    competitors.each { |comp| return false unless comp.finished? }
    true
  end

  def finished_competitors_count
    count = 0
    competitors.each do |comp|
      count += 1 if comp.finished?
    end
    count
  end

  def active?
    !finished? && !race.finished? && started?
  end

  def started?
    return race.start_datetime <= Time.zone.now if sport.shooting?
    start_time && start_datetime < Time.zone.now
  end

  def start_datetime
    start_date_time race, start_day, start_time
  end

  def today?
    race.race_day == start_day
  end

  def each_competitor_has_correct_estimates?
    condition34 = (estimates == 4 ? ' or competitors.correct_estimate3 is null ' +
      'or competitors.correct_estimate4 is null' : '')
    competitors.where("competitors.correct_estimate1 is null or " +
        "competitors.correct_estimate2 is null#{condition34}").empty?
  end

  def has_unofficial_competitors?
    competitors.where(:unofficial => true).exists?
  end

  def competitors_only_to_age_groups?
    !!(name =~ /^S\d\d?$/)
  end

  def age_groups_with_main_series
    return [] if age_groups.empty?
    groups = age_groups
    unless competitors_only_to_age_groups?
      dummy_age_group_with_series_name = AgeGroup.new(name: name)
      groups = [dummy_age_group_with_series_name] + groups
    end
    groups
  end

  def update_start_time_and_number
    return unless has_start_list?
    self.start_time = competitors.minimum(:start_time)
    self.first_number = competitors.minimum(:number)
    save!
  end

  def has_result_for_some_competitor?
    competitors.where('has_result=?', true).exists?
  end

  def age_groups_with_shorter_trip
    age_groups.select {|age_group| age_group.shorter_trip}
  end

  def walking_series?
    points_method == POINTS_METHOD_300_TIME_2_ESTIMATES || points_method == POINTS_METHOD_NO_TIME_2_ESTIMATES ||
        points_method == POINTS_METHOD_NO_TIME_4_ESTIMATES
  end

  def time_points?
    points_method != POINTS_METHOD_300_TIME_2_ESTIMATES && points_method != POINTS_METHOD_NO_TIME_2_ESTIMATES
  end

  def with_time?
    !walking_series?
  end

  private
  def check_points_method
    self.points_method = POINTS_METHOD_TIME_2_ESTIMATES if points_method == nil
  end

  def strip_series
    self.name = name.strip if name
  end

  def set_estimates
    if [POINTS_METHOD_TIME_4_ESTIMATES, POINTS_METHOD_NO_TIME_4_ESTIMATES].include? points_method
      self.estimates = 4
    else
      self.estimates = 2
    end
  end

  def set_has_start_list
    return unless race
    self.has_start_list ||= (race.start_order.to_i == Race::START_ORDER_MIXED)
    true
  end

  def touch_race
    race.touch
  end

  def start_time_max
    errors.add :start_time, :too_big if start_time && start_time > Competitor::MAX_START_TIME
  end

  def start_day_not_bigger_than_race_days_count
    if race and start_day > race.days_count
      errors.add(:start_day, "ei voi olla suurempi kuin kilpailupäivien määrä")
    end
  end

  def can_generate_numbers?
    ok = true
    unless first_number
      errors.add :base, :cannot_generate_numbers_without_first_number
      ok = false
    end
    if some_competitor_has_arrival_time?
      errors.add :base, :cannot_generate_numbers_already_arrival_times
      ok = false
    end
    if first_number
      max_number = first_number + competitors.count - 1
      unless race.competitors.where(['series_id<>? and number>=? and number<=?',
          id, first_number, max_number]).empty?
        errors.add :base, :cannot_generate_numbers_no_free_numbers,
          :first_number => first_number, :max_number => max_number
        ok = false
      end
    end
    ok
  end

  def can_generate_start_times?
    ok = true
    unless start_time
      errors.add :base, :cannot_generate_start_times_without_start_time
      ok = false
    end
    unless first_number
      errors.add :base, :cannot_generate_start_times_without_first_number
      ok = false
    end
    unless each_competitor_has_number?
      errors.add :base, :cannot_generate_start_times_without_numbers_for_all_competitors
      ok = false
    end
    if some_competitor_has_arrival_time?
      errors.add :base, :cannot_generate_start_times_already_arrival_times
      ok = false
    end
    ok
  end

  def set_start_times_for_competitors(competitors, batch_size,
      last_batch_start, last_batch_size, batch_interval)
    interval = race.start_interval_seconds
    competitors.each do |comp|
      time_diff = time_diff_to_series_start_time(comp, interval,
        batch_size, last_batch_start, last_batch_size, batch_interval)
      comp.update_column(:start_time, start_time + time_diff)
    end
  end

  def time_diff_to_series_start_time(competitor, interval, batch_size,
      last_batch_start, last_batch_size, batch_interval)
    comp_num_diff = (competitor.number - first_number)
    time_diff = comp_num_diff * interval
    if batch_size > 0
      time_diff += (comp_num_diff / batch_size).to_i * batch_interval
      if batch_too_small?(competitor, last_batch_start, last_batch_size, batch_size)
        time_diff -= batch_interval # attach to previous batch
      end
    end
    time_diff
  end

  def batch_too_small?(competitor, last_batch_start, last_batch_size, batch_size)
    competitor.number >= last_batch_start && last_batch_size <= batch_size*2/3
  end
end
