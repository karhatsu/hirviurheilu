class RelayTeam < ApplicationRecord
  DNS = 'DNS' # did not start
  DNF = 'DNF' # did not finish
  DQ = 'DQ' # disqualified

  belongs_to :relay, touch: true
  has_many :relay_competitors, -> { order :leg }, :dependent => :destroy

  validates :name, :presence => true
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 },
    :uniqueness => { :scope => :relay_id }
  validate :check_no_result_reason

  accepts_nested_attributes_for :relay_competitors, :allow_destroy => true

  def competitor(leg)
    competitor = relay_competitors[leg.to_i - 1] # faster solution but not reliable
    return competitor if competitor && competitor.leg == leg.to_i
    relay_competitors.where(:leg => leg).first # slower and reliable solution
  end

  def time_in_seconds(leg=nil, with_penalty_seconds=false)
    leg = relay.legs_count unless leg
    competitor = competitor(leg)
    return nil unless competitor&.arrival_time
    time = competitor.arrival_time - competitor(1).start_time + adjustment(leg) + estimate_adjustment(leg) + shooting_adjustment(leg)
    return time unless with_penalty_seconds
    time + penalty_seconds(leg)
  end

  def estimate_penalties_sum
    sum = nil
    relay_competitors.each do |competitor|
      unless competitor.estimate_penalties.nil?
        sum = sum.to_i + competitor.estimate_penalties.to_i
      end
    end
    sum
  end

  def adjustment(leg=nil)
    leg = relay.legs_count unless leg
    sum = 0
    leg.to_i.times do |i|
      competitor = competitor(i + 1)
      sum += competitor.adjustment.to_i if competitor
    end
    sum
  end

  def estimate_adjustment(leg=nil)
    return 0 unless relay.leg_distance && relay.estimate_penalty_distance
    leg = relay.legs_count unless leg
    sum = 0
    leg.to_i.times do |i|
      competitor = competitor(i + 1)
      sum += competitor.estimate_adjustment.to_i if competitor
    end
    sum
  end

  def shooting_adjustment(leg=nil)
    return 0 unless relay.leg_distance && relay.shooting_penalty_distance
    leg = relay.legs_count unless leg
    sum = 0
    leg.to_i.times do |i|
      competitor = competitor(i + 1)
      sum += competitor.shooting_adjustment.to_i if competitor
    end
    sum
  end

  def shoot_penalties_sum
    sum = nil
    relay_competitors.each do |competitor|
      unless competitor.misses.nil?
        sum = sum.to_i + competitor.misses.to_i
      end
    end
    sum
  end

  def penalty_seconds(leg=nil)
    return 0 unless relay.penalty_seconds
    leg = relay.legs_count unless leg
    sum = 0
    leg.to_i.times do |i|
      competitor = competitor(i + 1)
      sum += competitor.penalty_seconds.to_i if competitor
    end
    sum
  end

  private
  def check_no_result_reason
    self.no_result_reason = nil if no_result_reason == ''
    unless [nil, DNS, DNF, DQ].include?(no_result_reason)
      errors.add(:no_result_reason,
        "Tuntematon syy tuloksen puuttumiselle: '#{no_result_reason}'")
    end
  end
end
