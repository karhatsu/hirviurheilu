class Series < ActiveRecord::Base
  belongs_to :race
  has_many :age_groups, :dependent => :destroy
  has_many :competitors, :order => 'number, id'
  has_many :start_list, :class_name => "Competitor", :foreign_key => 'series_id',
    :conditions => "start_time is not null", :order => "start_time"

  accepts_nested_attributes_for :age_groups, :allow_destroy => true

  validates :name, :presence => true
  validates :race, :presence => true
  validates :first_number, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validate :start_time_during_race_dates

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
      [a.no_result_reason.to_s, b.points.to_i, b.shot_points.to_i, b.time_points.to_i, b.points!.to_i] <=>
        [b.no_result_reason.to_s, a.points.to_i, a.shot_points.to_i, a.time_points.to_i, a.points!.to_i]
    end
  end

  def next_number
    unless competitors.empty?
      max = competitors.maximum(:number)
      return max + 1 if max
    end
    return first_number if first_number
    1
  end

  def next_start_time
    unless competitors.empty?
      latest = competitors.last
      return latest.start_time + race.start_interval_seconds if latest and latest.start_time
    end
    return start_time if start_time
    nil
  end

  def generate_start_list
    return false unless generate_numbers
    return false unless generate_start_times
    self.has_start_list = true
    save!
  end

  def generate_start_list!
    generate_numbers!
    generate_start_times!
    self.has_start_list = true
    save!
  end

  def generate_numbers
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
    return false if failure

    competitors.each_with_index do |comp, i|
      comp.number = first_number + i
      comp.save!
    end
    true
  end

  def generate_numbers!
    generate_numbers || raise(errors.full_messages.to_s)
  end

  def generate_start_times
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
      comp.start_time = time.strftime('%H:%M:%S')
      comp.save!
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
    return false unless correct_estimate1 and correct_estimate2
    return false unless each_competitor_finished?
    true
  end

  def running?
    start_time and start_time < Time.now and not race.finished
  end

  private
  def start_time_during_race_dates
    return unless start_time
    end_date = race.end_date ? race.end_date : end_date = race.start_date
    if start_time < race.start_date.beginning_of_day or start_time > end_date.end_of_day
      errors.add(:start_time, "pitää olla kilpailupäivien aikana")
    end
  end

  def prevent_destroy_if_competitors
    unless competitors.empty?
      errors.add(:base, "Sarjan voi poistaa vain jos siinä ei ole kilpailijoita")
      return false
    end
  end

end
