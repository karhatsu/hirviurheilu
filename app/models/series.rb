class Series < ActiveRecord::Base
  has_many :competitors

  validates :name, :presence => true

  def best_time_in_seconds
    dummy_big = 999999999
    times = competitors.collect do |comp|
      # TODO: fix the ugly code
      if comp.time_in_seconds.nil?
        dummy_big
      else
        comp.time_in_seconds
      end
    end
    times.sort!
    return nil if times.first == dummy_big
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
