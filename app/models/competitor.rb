class Competitor < ActiveRecord::Base
  belongs_to :club

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :year_of_birth, :numericality => { :only_integer => true,
    :greater_than => 1899, :less_than => 2101 }
  validates :shot1, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shot2, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shot3, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shot4, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shot5, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shot6, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shot7, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shot8, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shot9, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shot10, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 11 }
  validates :shots_total_input, :allow_nil => true,
    :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 101 }
  validates :estimate1, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => -1 }
  validates :estimate2, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => -1 }
  validate :arrival_not_before_start_time

  def shots_sum
    return shots_total_input if shots_total_input
    return nil if shot1.nil?
    shot1.to_i + shot2.to_i + shot3.to_i + shot4.to_i + shot5.to_i +
      shot6.to_i + shot7.to_i + shot8.to_i + shot9.to_i + shot10.to_i
  end

  def time_in_seconds
    return nil if start_time.nil? or arrival_time.nil?
    arrival_time - start_time
  end

  def shot_points
    sum = shots_sum
    return nil if sum.nil?
    6 * sum
  end

  def estimate_points(correct1, correct2)
    return nil if estimate1.nil? or estimate2.nil?
    points = 300 - 2 * (correct1 - estimate1).abs - 2 * (correct2 - estimate2).abs
    return points if points >= 0
    0
  end

  def time_points(best_time_in_seconds)
    own_time = time_in_seconds
    return nil if own_time.nil?
    points = 300 - (own_time - best_time_in_seconds) / 6
    return points if points >= 0
    0
  end

  protected
  def arrival_not_before_start_time
    return if start_time.nil?
    errors.add(:arrival_time, :arrival_not_before_start_time) if start_time > arrival_time
  end

end
