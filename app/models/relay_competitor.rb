class RelayCompetitor < ApplicationRecord
  belongs_to :relay_team, touch: true

  before_validation :set_start_time

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :misses, :numericality => { :only_integer => true, :allow_nil => true,
    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5 }
  validates :estimate, :numericality => { :only_integer => true, :allow_nil => true,
    :greater_than => 0 }
  validates :adjustment, :numericality => { :only_integer => true, :allow_nil => true }
  validates :leg, :numericality => { :only_integer => true, :greater_than => 0 },
    :uniqueness => { :scope => :relay_team_id }
  validates :estimate_penalties_adjustment, numericality: { only_integer: true, allow_nil: true }
  validates :shooting_penalties_adjustment, numericality: { only_integer: true, allow_nil: true }
  validate :leg_not_bigger_than_relay_legs_count
  validate :arrival_not_before_start_time
  validate :compare_arrival_time_to_next_competitor

  after_update :set_next_competitor_start_time

  delegate :relay, to: :relay_team

  def previous_competitor
    return nil if leg == 1
    relay_team.relay_competitors.where(:leg => leg - 1).first
  end

  def next_competitor
    return nil if relay_team.nil? or leg == relay_team.relay.legs_count
    relay_team.relay_competitors.where(:leg => leg + 1).first
  end

  def estimate_penalties
    return nil unless estimate
    correct_estimate = relay_team.relay.correct_estimate(leg)
    return nil unless correct_estimate
    diff = (correct_estimate - estimate).abs
    return 0 if diff == 0
    penalties = (diff - 1) / 5
    return 5 if penalties > 5
    penalties
  end

  def time_in_seconds(with_penalty_seconds = false)
    return nil if start_time.nil? || arrival_time.nil?
    time = arrival_time - start_time + adjustment.to_i + estimate_adjustment.to_i + shooting_adjustment.to_i
    return time unless with_penalty_seconds && relay.penalty_seconds?
    time + penalty_seconds
  end

  def estimate_adjustment
    time = arrival_time - start_time if start_time && arrival_time
    return 0 unless time && relay.leg_distance && relay.estimate_penalty_distance
    distance_adjustment = estimate_penalties_adjustment.to_i * relay.estimate_penalty_distance
    (distance_adjustment.to_d / total_distance * time).round
  end

  def shooting_adjustment
    time = arrival_time - start_time if start_time && arrival_time
    return 0 unless time && relay.leg_distance && relay.shooting_penalty_distance
    distance_adjustment = shooting_penalties_adjustment.to_i * relay.shooting_penalty_distance
    (distance_adjustment.to_d / total_distance * time).round
  end

  def penalty_seconds
    relay.estimate_penalty_seconds * estimate_penalties.to_i + relay.shooting_penalty_seconds * misses
  end

  private
  def leg_not_bigger_than_relay_legs_count
    if relay_team and leg > relay_team.relay.legs_count
      errors.add(:leg, 'ei voi olla suurempi kuin viestin osuuksien määrä')
    end
  end

  def arrival_not_before_start_time
    return if start_time.nil? and arrival_time.nil?
    if start_time.nil?
      errors.add(:base,
        'Kilpailijalla ei voi olla saapumisaikaa, jos hänellä ei ole lähtöaikaa')
      return
    end
    if arrival_time and start_time >= arrival_time
      errors.add(:arrival_time, "pitää olla lähtöajan jälkeen")
    end
  end

  def compare_arrival_time_to_next_competitor
    return unless arrival_time
    next_comp = next_competitor
    if next_comp and next_comp.arrival_time and arrival_time >= next_comp.arrival_time
      errors.add(:arrival_time, 'täytyy olla ennen seuraavan kilpailijan saapumisaikaa')
    end
  end

  def set_start_time
    return unless relay_team
    if leg == 1
      self.start_time = '00:00'
    else
      prev = previous_competitor
      self.start_time = prev.arrival_time if prev
    end
  end

  def set_next_competitor_start_time
    comp = next_competitor
    if comp
      comp.start_time = arrival_time
      comp.save!
    end
  end

  def total_distance
    relay.leg_distance +
        (estimate_penalties.to_i - estimate_penalties_adjustment.to_i) * relay.estimate_penalty_distance +
        (misses.to_i - shooting_penalties_adjustment.to_i) * relay.shooting_penalty_distance
  end
end
