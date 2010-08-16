class Series < ActiveRecord::Base
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
    best_time = best_time_in_seconds
    competitors.sort do |a, b|
      [b.points(best_time).to_i, b.points!(best_time).to_i] <=>
        [a.points(best_time).to_i, a.points!(best_time).to_i]
    end
  end

end
