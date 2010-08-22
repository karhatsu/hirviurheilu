class Series < ActiveRecord::Base
  belongs_to :race
  has_many :competitors
  has_many :start_list, :class_name => "Competitor", :foreign_key => 'series_id',
    :conditions => "start_time is not null", :order => "start_time"

  validates :name, :presence => true
  validates :race, :presence => true

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
      [a.no_result_reason.to_s, b.points.to_i, b.points!.to_i] <=>
        [b.no_result_reason.to_s, a.points.to_i, a.points!.to_i]
    end
  end

end
