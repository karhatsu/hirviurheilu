# encoding: UTF-8
require 'database_helper.rb'
require 'time_helper.rb'

class Series < ActiveRecord::Base
  include TimeHelper
  include StartDateTime

  TIME_POINTS_TYPE_NORMAL = 0
  TIME_POINTS_TYPE_NONE = 1
  TIME_POINTS_TYPE_ALL_300 = 2

  START_LIST_ADDING_ORDER = 0
  START_LIST_RANDOM = 1

  belongs_to :race, :counter_cache => true
  has_many :age_groups, :dependent => :destroy
  has_many :competitors, :dependent => :destroy, :order => 'number, id'
  has_many :start_list, :class_name => "Competitor", :foreign_key => 'series_id',
    :conditions => "start_time is not null", :order => "start_time, number"

  accepts_nested_attributes_for :age_groups, :allow_destroy => true
  accepts_nested_attributes_for :competitors

  before_validation :check_time_points_type

  validates :name, :presence => true
  #validates :race, :presence => true
  validates :first_number, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validates :start_day, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validates :estimates, :numericality => { :only_integer => true },
    :inclusion => { :in => [2, 4] }
  validates :national_record, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validates :time_points_type,
    :inclusion => { :in => [TIME_POINTS_TYPE_NORMAL, TIME_POINTS_TYPE_NONE,
      TIME_POINTS_TYPE_ALL_300] }
  validate :start_day_not_bigger_than_race_days_count
  
  before_create :set_has_start_list
  
  def best_time_in_seconds(age_group_ids, all_competitors)
    @best_time_cache ||= Hash.new
    cache_key = age_group_ids.to_s + all_competitors.to_s
    return @best_time_cache[cache_key] if @best_time_cache.has_key?(cache_key)
    conditions = { :no_result_reason => nil }
    conditions[:unofficial] = false unless all_competitors
    conditions[:age_group_id] = age_group_ids if age_group_ids
    time = competitors.minimum(time_subtraction_sql, :conditions => conditions)
    if time
      @best_time_cache[cache_key] = time.to_i
      return time.to_i
    else
      @best_time_cache[cache_key] = nil
      return nil
    end
  end
  
  def comparison_time_in_seconds(age_group, all_competitors)
    return best_time_in_seconds(nil, all_competitors) unless age_group
    @age_group_ids ||= age_group_comparison_group_ids(all_competitors)
    best_time_in_seconds(@age_group_ids[age_group], all_competitors)
  end
  
  def ordered_competitors(all_competitors, sort_by=Competitor::SORT_BY_POINTS)
    Competitor.sort_competitors(competitors.includes([:shots, :club, :age_group, :series]), all_competitors, sort_by)
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

  def ready?
    return false unless has_start_list?
    return false unless each_competitor_finished?
    true
  end

  def active?
    !race.finished and started?
  end

  def started?
    start_time and start_datetime < Time.zone.now
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
    groups.unshift(AgeGroup.new(:id => nil, :name => name)) unless competitors_only_to_age_groups?
    groups
  end
  
  def update_start_time_and_number
    return unless has_start_list?
    self.start_time = competitors.minimum(:start_time)
    self.first_number = competitors.minimum(:number)
    save!
  end
  
  def has_result_for_some_competitor?
    competitors.where('arrival_time is not null or estimate1 is not null or estimate2 is not null or ' +
      'shots_total_input is not null').exists?
  end

  private
  def check_time_points_type
    self.time_points_type = TIME_POINTS_TYPE_NORMAL if time_points_type == nil
  end

  def time_subtraction_sql
    return "EXTRACT(EPOCH FROM (arrival_time-start_time))" if DatabaseHelper.postgres?
    return "strftime('%s', arrival_time)-strftime('%s', start_time)" if DatabaseHelper.sqlite3?
    raise "Unknown database adapter"
  end
  
  def set_has_start_list
    return unless race
    self.has_start_list ||= (race.start_order.to_i == Race::START_ORDER_MIXED)
    true
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
  
  def age_group_comparison_group_ids(all_competitors)
    ordered_age_groups = age_groups.order('name desc')
    unless each_group_starts_with_same_letter(ordered_age_groups)
      return build_age_group_to_own_id_hash ordered_age_groups
    end
    
    groupped_age_groups, age_groups_without_enough_competitors =
      build_groupped_age_groups(ordered_age_groups, all_competitors)

    # hash: { age_group => [own age group id, another age group id, ...] }
    hash = build_hash_for_groups_without_enough_competitors(age_groups_without_enough_competitors)
    build_hash_for_groups_with_enough_competitors hash, groupped_age_groups
  end

  def each_group_starts_with_same_letter(age_groups)
    return false if age_groups.empty?
    first_letter = age_groups[0].name[0]
    age_groups.each do |age_group|
      return false unless first_letter == age_group.name[0]
    end
    true
  end
  
  def build_age_group_to_own_id_hash(age_groups)
    hash = {}
    age_groups.each do |age_group|
      hash[age_group] = age_group.id
    end
    return hash
  end
  
  def build_groupped_age_groups(ordered_age_groups, all_competitors)
    groupped_age_groups = []
    groupped_age_group = []
    competitors_count = 0
    ordered_age_groups.each do |age_group|
      groupped_age_group << age_group
      competitors_count += age_group.competitors_count(all_competitors)
      if competitors_count >= age_group.min_competitors
        groupped_age_groups << groupped_age_group
        groupped_age_group = []
        competitors_count = 0
      end
    end
    return groupped_age_groups, groupped_age_group
  end
  
  def build_hash_for_groups_without_enough_competitors(age_groups_without_enough_competitors)
    hash = {}
    age_groups_without_enough_competitors.each do |age_group|
      hash[age_group] = nil
    end
    hash
  end
  
  def build_hash_for_groups_with_enough_competitors(hash, groupped_age_groups)
    groupped_age_groups.each do |group|
      group.each do |age_group|
        ids = []
        own_group = false
        groupped_age_groups.each do |group2|
          group2.each do |age_group2|
            ids << age_group2.id
            own_group = true if age_group == age_group2
          end
          break if own_group
        end
        hash[age_group] = ids
      end
    end
    hash
  end
end
