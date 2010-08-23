class Series < ActiveRecord::Base
  belongs_to :race
  has_many :competitors
  has_many :start_list, :class_name => "Competitor", :foreign_key => 'series_id',
    :conditions => "start_time is not null", :order => "start_time"

  validates :name, :presence => true
  validates :race, :presence => true
  validates :first_number, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
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
      [a.no_result_reason.to_s, b.points.to_i, b.shot_points.to_i, b.points!.to_i] <=>
        [b.no_result_reason.to_s, a.points.to_i, a.shot_points.to_i, a.points!.to_i]
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

  private
  def start_time_during_race_dates
    return unless start_time
    end_date = race.end_date ? race.end_date : end_date = race.start_date
    if start_time < race.start_date.beginning_of_day or start_time > end_date.end_of_day
      errors.add(:start_time, "Aloitusajan pitää olla kilpailupäivien aikana")
    end
  end

end
