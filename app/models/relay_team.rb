class RelayTeam < ActiveRecord::Base
  DNS = 'DNS' # did not start
  DNF = 'DNF' # did not finish

  belongs_to :relay
  has_many :relay_competitors, :dependent => :destroy, :order => 'leg'

  validates :name, :presence => true
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 },
    :uniqueness => { :scope => :relay_id }
  validate :check_no_result_reason

  accepts_nested_attributes_for :relay_competitors

  def competitor(leg)
    competitor = relay_competitors[leg.to_i - 1] # faster solution but not reliable
    return competitor if competitor and competitor.leg == leg.to_i
    relay_competitors.where(:leg => leg).first # slower and reliable solution
  end

  def time_in_seconds(leg=nil)
    leg = relay.legs_count unless leg
    competitor = competitor(leg)
    return nil unless competitor and competitor.arrival_time
    competitor.arrival_time - relay.start_time + adjustment(leg)
  end

  def estimate_penalties_sum
    sum = 0
    relay_competitors.each do |competitor|
      sum += competitor.estimate_penalties.to_i
    end
    return sum
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

  def shoot_penalties_sum
    sum = 0
    relay_competitors.each do |competitor|
      sum += competitor.misses.to_i
    end
    return sum
  end

  private
  def check_no_result_reason
    self.no_result_reason = nil if no_result_reason == ''
    unless [nil, DNS, DNF].include?(no_result_reason)
      errors.add(:no_result_reason,
        "Tuntematon syy tuloksen puuttumiselle: '#{no_result_reason}'")
    end
  end
end
