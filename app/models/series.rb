class Series < ActiveRecord::Base
  belongs_to :contest
  has_many :competitors

  validates :name, :presence => true

  def best_time_in_seconds
    times = []
    competitors.each do |comp|
      times << comp.time_in_seconds unless comp.time_in_seconds.nil?
    end
    times.sort!
    times.first
  end

  def ordered_competitors
    competitors.sort do |a, b|
      [b.points.to_i, b.points!.to_i] <=> [a.points.to_i, a.points!.to_i]
    end
  end

end
