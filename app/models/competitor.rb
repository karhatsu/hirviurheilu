class Competitor < ActiveRecord::Base
  belongs_to :club
  belongs_to :series

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

  def shot_values
    [shot1, shot2, shot3, shot4, shot5, shot6, shot7, shot8, shot9, shot10]
  end

  def shots_sum
    return shots_total_input if shots_total_input
    return nil if shot1.nil?
    sum = 0
    shot_values.each do |s|
      sum += s.to_i
    end
    sum
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

  def estimate_diff1_m
    return nil if estimate1.nil?
    estimate1 - series.correct_estimate1
  end

  def estimate_diff2_m
    return nil if estimate2.nil?
    estimate2 - series.correct_estimate2
  end

  def estimate_points
    return nil if estimate1.nil? or estimate2.nil?
    points = 300 - 2 * (series.correct_estimate1 - estimate1).abs -
      2 * (series.correct_estimate2 - estimate2).abs
    return points if points >= 0
    0
  end

  def time_points
    own_time = time_in_seconds
    return nil if own_time.nil?
    points = 300 - (own_time - series.best_time_in_seconds) / 6
    return points.to_i if points >= 0
    0
  end

  def points
    sp = shot_points
    return nil if sp.nil?
    ep = estimate_points
    return nil if ep.nil?
    tp = time_points
    return nil if tp.nil?
    sp + ep + tp
  end

  def points!
    shot_points.to_i + estimate_points.to_i + time_points.to_i
  end

  protected
  def arrival_not_before_start_time
    return if start_time.nil? or arrival_time.nil?
    errors.add(:arrival_time, :arrival_not_before_start_time) if start_time > arrival_time
  end

end
