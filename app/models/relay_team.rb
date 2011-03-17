class RelayTeam < ActiveRecord::Base
  DNS = 'DNS' # did not start
  DNF = 'DNF' # did not finish

  belongs_to :relay
  has_many :relay_competitors, :order => 'leg'

  validates :name, :presence => true
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 },
    :uniqueness => { :scope => :relay_id }
  validate :check_no_result_reason

  accepts_nested_attributes_for :relay_competitors

  def time_in_seconds(leg=nil)
    leg = relay.legs_count unless leg
    competitor = relay_competitors.where(:leg => leg).first
    return nil unless competitor and competitor.arrival_time
    competitor.arrival_time - relay.start_time
  end

  def estimate_penalties_sum
    sum = 0
    relay_competitors.each do |competitor|
      sum += competitor.estimate_penalties if competitor.estimate_penalties
    end
    return sum
  end

  def shoot_penalties_sum
    sum = 0
    relay_competitors.each do |competitor|
      sum += competitor.misses if competitor.misses
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
