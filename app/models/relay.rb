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
    leg_results(legs_count)
  end

  def leg_results(leg)
    competitors = relay_competitors.where(:leg => leg).order('arrival_time')
    competitors.collect do |competitor| competitor.relay_team end
  end

  def finish
    unless start_time
      errors.add(:base, 'Viestiltä puuttuu aloitusaika')
      return false
    end
    if relay_teams.empty?
      errors.add(:base, 'Viestissä ei ole yhtään joukkuetta')
      return false
    end
    if relay_correct_estimates.empty?
      errors.add(:base, 'Viestistä puuttuu oikeat arviot')
      return false
    end
    relay_competitors.each do |competitor|
      if competitor.arrival_time.nil?
        errors.add(:base, 'Osalta kilpailijoista puuttuu saapumisaika')
        return false
      elsif competitor.misses.nil?
        errors.add(:base, 'Osalta kilpailijoista puuttuu ohilaukausten määrä')
        return false
      elsif competitor.estimate.nil?
        errors.add(:base, 'Osalta kilpailijoista puuttuu arvio')
        return false
      end
    end
    relay_correct_estimates.each do |ce|
      if ce.distance.nil?
        errors.add(:base, 'Viestistä puuttuu oikeat arviot')
        return false
      end
    end
    self.finished = true
    save!
    true
  end

  def finish!
    finish || raise(errors.full_messages.to_s)
  end

  private
  def start_day_not_bigger_than_race_days_count
    if race and start_day > race.days_count
      errors.add(:start_day, "ei voi olla suurempi kuin kilpailupäivien määrä")
    end
  end
end
