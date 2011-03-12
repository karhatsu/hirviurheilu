class Relay < ActiveRecord::Base
  belongs_to :race
  has_many :relay_teams, :order => 'number'
  has_many :relay_correct_estimates, :order => 'leg'
  has_many :relay_competitors, :through => :relay_teams

  validates :name, :presence => true
  validates :legs_count, :numericality => { :only_integer => true, :greater_than => 1 }
  validates :start_day, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validate :start_day_not_bigger_than_race_days_count

  attr_readonly :legs_count

  accepts_nested_attributes_for :relay_teams
  accepts_nested_attributes_for :relay_correct_estimates

  def correct_estimate(leg)
    ce = relay_correct_estimates.where(:leg => leg).first
    return ce.distance if ce
  end

  def results
    competitors = relay_competitors.where(:leg => legs_count).order('arrival_time')
    competitors.collect do |competitor| competitor.relay_team end
  end

  private
  def start_day_not_bigger_than_race_days_count
    if race and start_day > race.days_count
      errors.add(:start_day, "ei voi olla suurempi kuin kilpailupäivien määrä")
    end
  end
end
