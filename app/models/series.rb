class Series < ActiveRecord::Base
  START_LIST_ADDING_ORDER = 0
  START_LIST_RANDOM = 1

  belongs_to :race, :counter_cache => true
  has_many :age_groups, :dependent => :destroy
  has_many :competitors, :order => 'number, id'
  has_many :start_list, :class_name => "Competitor", :foreign_key => 'series_id',
    :conditions => "start_time is not null", :order => "start_time"

  accepts_nested_attributes_for :age_groups, :allow_destroy => true

  validates :name, :presence => true
  validates :race, :presence => true
  validates :first_number, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validates :start_day, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validate :start_day_not_bigger_than_race_days_count
  
  before_destroy :prevent_destroy_if_competitors

  def best_time_in_seconds
    if @seconds_cache
      return @seconds_cache
    end
    @seconds_cache = Series.best_time_in_seconds(competitors)
  end

  def self.best_time_in_seconds(competitors)
    times = []
    competitors.each do |comp|
      times << comp.time_in_seconds unless comp.time_in_seconds.nil? or
        comp.no_result_reason
    end
    times.sort!
    times.first
  end

  def ordered_competitors
    competitors.sort do |a, b|
      [a.no_result_reason.to_s, b.points.to_i, b.shot_points.to_i, a.time_in_seconds.to_i, b.points!.to_i] <=>
        [b.no_result_reason.to_s, a.points.to_i, a.shot_points.to_i, b.time_in_seconds.to_i, a.points!.to_i]
    end
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
    failure = false
    error_start = 'Numeroita ei voi generoida'
    unless first_number
      errors.add(:base, "#{error_start}, sillä sarjan ensimmäistä numeroa ei ole määritetty")
      failure = true
    end
    competitors.each do |comp|
      if comp.arrival_time
        errors.add(:base, "#{error_start}, sillä osalla kilpailijoista on jo saapumisaika")
        failure = true
        break
      end
    end
    if first_number
      max_number = first_number + competitors.count - 1
      unless race.competitors.where(['series_id<>? and number>=? and number<=?',
          id, first_number, max_number]).empty?
        errors.add(:base, "#{error_start}, sillä kilpailunumerot " +
          "#{first_number}-#{max_number} eivät ole vapaana")
        failure = true
      end
    end
    return false if failure

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

  def generate_start_times
    reload
    failure = false
    error_start = 'Lähtöaikoja ei voi generoida'
    unless start_time
      errors.add(:base, "#{error_start}, sillä sarjan lähtöaikaa ei ole määritetty")
      failure = true
    end
    unless first_number
      errors.add(:base, "#{error_start}, sillä sarjan ensimmäistä numeroa ei ole määritetty")
      failure = true
    end
    unless each_competitor_has_number?
      errors.add(:base, "#{error_start}, sillä kaikilla kilpailijoilla ei ole numeroa")
      failure = true
    end
    competitors.each do |comp|
      if comp.arrival_time
        errors.add(:base, "#{error_start}, sillä osalla kilpailijoista on jo saapumisaika")
        failure = true
        break
      end
    end
    return false if failure

    interval = race.start_interval_seconds
    competitors.each do |comp|
      # if the calculated time is saved as such, the time zone changes to UTC
      time = start_time + (comp.number - first_number) * interval
      comp.update_attribute(:start_time, time.strftime('%H:%M:%S'))
    end
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

  def running?
    start_time and start_time < Time.now and not race.finished
  end

  def each_competitor_has_correct_estimates?
    competitors.where('competitors.correct_estimate1 is null or ' +
        'competitors.correct_estimate2 is null').empty?
  end

  private
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
end
