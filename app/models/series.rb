# encoding: UTF-8
require 'database_helper.rb'
require 'time_helper.rb'

class Series < ActiveRecord::Base
  include TimeHelper

  TIME_POINTS_TYPE_NORMAL = 0
  TIME_POINTS_TYPE_NONE = 1
  TIME_POINTS_TYPE_ALL_300 = 2

  START_LIST_ADDING_ORDER = 0
  START_LIST_RANDOM = 1

  belongs_to :race, :counter_cache => true
  has_many :age_groups, :dependent => :destroy
  has_many :competitors, :order => 'number, id'
  has_many :start_list, :class_name => "Competitor", :foreign_key => 'series_id',
    :conditions => "start_time is not null", :order => "start_time"

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
  
  before_destroy :prevent_destroy_if_competitors

  def best_time_in_seconds(age_group_ids, all_competitors)
    conditions = { :no_result_reason => nil }
    conditions[:unofficial] = false unless all_competitors
    conditions[:age_group_id] = age_group_ids if age_group_ids
    time = competitors.minimum(time_subtraction_sql, :conditions => conditions)
    return time.to_i if time
  end
  
  def comparison_time_in_seconds(age_group, all_competitors)
    return best_time_in_seconds(nil, all_competitors) unless age_group
    @age_group_ids ||= age_group_comparison_group_ids(all_competitors)
    best_time_in_seconds(@age_group_ids[age_group], all_competitors)
  end
  
  def ordered_competitors(all_competitors)
    Competitor.sort(competitors.includes([:shots, :club, :age_group, :series]), all_competitors)
  end

  def next_number
    max = competitors.maximum(:number)
    return max + 1 if max
    return first_number if first_number
    1
  end

  def next_start_time
    latest = competitors.last
    return latest.start_time + race.start_interval_seconds if latest and latest.start_time
    return start_time if start_time
    nil
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
      comp.update_attribute(:number, first_number + i)
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
    competitors.each do |comp|
      return false if comp.number.nil?
    end
    true
  end

  def each_competitor_has_start_time?
    competitors.each do |comp|
      return false if comp.start_time.nil?
    end
    true
  end

  def each_competitor_finished?
    competitors.each do |comp|
      return false unless comp.finished?
    end
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
    return nil unless start_time and race and race.start_date
    time = Time.zone.local(race.start_date.year, race.start_date.month,
      race.start_date.day, start_time.hour, start_time.min, start_time.sec)
    time.advance(:days => start_day - 1)
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

  private
  def check_time_points_type
    self.time_points_type = TIME_POINTS_TYPE_NORMAL if time_points_type == nil
  end

  def time_subtraction_sql
    return "EXTRACT(EPOCH FROM (arrival_time-start_time))" if DatabaseHelper.postgres?
    return "strftime('%s', arrival_time)-strftime('%s', start_time)" if DatabaseHelper.sqlite3?
    raise "Unknown database adapter"
  end

  def prevent_destroy_if_competitors
    if competitors.count > 0
      errors.add(:base, "Sarjan voi poistaa vain jos siinä ei ole kilpailijoita")
      return false
    end
  end

  def start_day_not_bigger_than_race_days_count
    if race and start_day > race.days_count
      errors.add(:start_day, "ei voi olla suurempi kuin kilpailupäivien määrä")
    end
  end

  def can_generate_numbers?
    ok = true
    error_start = 'Numeroita ei voi generoida'
    unless first_number
      errors.add(:base, "#{error_start}, sillä sarjan ensimmäistä numeroa ei ole määritetty")
      ok = false
    end
    if some_competitor_has_arrival_time?
      errors.add(:base, "#{error_start}, sillä osalla kilpailijoista on jo saapumisaika")
      ok = false
    end
    if first_number
      max_number = first_number + competitors.count - 1
      unless race.competitors.where(['series_id<>? and number>=? and number<=?',
          id, first_number, max_number]).empty?
        errors.add(:base, "#{error_start}, sillä kilpailunumerot " +
          "#{first_number}-#{max_number} eivät ole vapaana")
        ok = false
      end
    end
    ok
  end

  def can_generate_start_times?
    ok = true
    error_start = 'Lähtöaikoja ei voi generoida'
    unless start_time
      errors.add(:base, "#{error_start}, sillä sarjan lähtöaikaa ei ole määritetty")
      ok = false
    end
    unless first_number
      errors.add(:base, "#{error_start}, sillä sarjan ensimmäistä numeroa ei ole määritetty")
      ok = false
    end
    unless each_competitor_has_number?
      errors.add(:base, "#{error_start}, sillä kaikilla kilpailijoilla ei ole numeroa")
      ok = false
    end
    if some_competitor_has_arrival_time?
      errors.add(:base, "#{error_start}, sillä osalla kilpailijoista on jo saapumisaika")
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
      comp.update_attribute(:start_time, start_time + time_diff)
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
