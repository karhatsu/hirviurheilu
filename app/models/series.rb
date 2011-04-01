class Series < ActiveRecord::Base
  START_LIST_ADDING_ORDER = 0
  START_LIST_RANDOM = 1

  belongs_to :race, :counter_cache => true
  has_many :age_groups, :dependent => :destroy
  has_many :competitors, :order => 'number, id'
  has_many :start_list, :class_name => "Competitor", :foreign_key => 'series_id',
    :conditions => "start_time is not null", :order => "start_time"

  accepts_nested_attributes_for :age_groups, :allow_destroy => true
  accepts_nested_attributes_for :competitors

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
  validate :start_day_not_bigger_than_race_days_count
  
  before_destroy :prevent_destroy_if_competitors

  def best_time_in_seconds
    @seconds_cache ||= Series.best_time_in_seconds(self)
  end

  def self.best_time_in_seconds(group_with_competitors)
    times = []
    group_with_competitors.competitors.each do |comp|
      times << comp.time_in_seconds unless comp.time_in_seconds.nil? or
        comp.no_result_reason or comp.unofficial
    end
    times.sort!
    times.first
  end

  def ordered_competitors
    Competitor.sort(competitors.includes([:shots, :club, :age_group]))
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
    if some_competitor_has_arrival_time?
      errors.add(:base, "#{error_start}, sillä osalla kilpailijoista on jo saapumisaika")
      failure = true
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

  def some_competitor_has_arrival_time?
    competitors.each do |comp|
      return true if comp.arrival_time
    end
    false
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
    if some_competitor_has_arrival_time?
      errors.add(:base, "#{error_start}, sillä osalla kilpailijoista on jo saapumisaika")
      failure = true
    end
    return false if failure

    interval = race.start_interval_seconds
    batch_size = race.batch_size
    batch_interval = race.batch_interval_seconds - interval
    # calculate where last (possibly partial) batch starts
    if batch_size > 0
      last_batch_size = (competitors.last.number - first_number + 1) % batch_size
      last_batch_start = 
        Integer((competitors.last.number - first_number + 1) / batch_size) * batch_size + first_number
    end
    if last_batch_start == first_number
      batch_size = 0
    end

    competitors.each do |comp|
      # if the calculated time is saved as such, the time zone changes to UTC
      comp_num_diff = (comp.number - first_number)
      timediff = comp_num_diff * interval
      if batch_size > 0
        timediff += Integer(comp_num_diff / batch_size) * batch_interval
        if comp.number >= last_batch_start && last_batch_size <= batch_size*2/3
          # partial batch less than 2/3 of batch size, attach to previous batch
          timediff -= batch_interval
        end
      end
      time = start_time + timediff
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
    start_time and start_time < Time.zone.now and not race.finished
  end

  def each_competitor_has_correct_estimates?
    condition34 = (estimates == 4 ? ' or competitors.correct_estimate3 is null ' +
      'or competitors.correct_estimate4 is null' : '')
    competitors.where("competitors.correct_estimate1 is null or " +
        "competitors.correct_estimate2 is null#{condition34}").empty?
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
