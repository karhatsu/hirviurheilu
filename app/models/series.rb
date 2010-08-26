class Series < ActiveRecord::Base
  OWN_TIME_POINTS_FOR_DIFFERENT_SEXES = 1

  belongs_to :race
  has_many :competitors
  has_many :start_list, :class_name => "Competitor", :foreign_key => 'series_id',
    :conditions => "start_time is not null", :order => "start_time"

  validates :name, :presence => true
  validates :race, :presence => true
  validates :first_number, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validates :time_method, :allow_nil => true,
    :inclusion => { :in => [OWN_TIME_POINTS_FOR_DIFFERENT_SEXES] }
  validate :start_time_during_race_dates

  def best_time_in_seconds
    times = []
    competitors.each do |comp|
      times << comp.time_in_seconds unless comp.time_in_seconds.nil? or comp.no_result_reason
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
    unless race.start_interval_seconds
      errors.add(:base, "#{error_start}, sillä kilpailulle ei ole määritetty lähtöaikojen väliä")
      failure = true
    end
    competitors.each do |comp|
      if comp.number.nil?
        errors.add(:base, "#{error_start}, sillä kaikilla kilpailijoilla ei ole numeroa")
        failure = true
        break
      end
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

  def running?
    start_time and start_time < Time.now and not race.finished
  end

  private
  def start_time_during_race_dates
    return unless start_time
    end_date = race.end_date ? race.end_date : end_date = race.start_date
    if start_time < race.start_date.beginning_of_day or start_time > end_date.end_of_day
      errors.add(:start_time, "Aloitusajan pitää olla kilpailupäivien aikana")
    end
  end

end
