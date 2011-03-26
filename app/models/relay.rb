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
    ce = relay_correct_estimates[leg - 1] # faster solution but not reliable
    return ce.distance if ce and ce.leg == leg
    ce = relay_correct_estimates.where(:leg => leg).first # slower and reliable solution
    return ce.distance if ce
  end

  def results
    leg_results(legs_count)
  end

  def leg_results(leg)
    last_leg = (leg == legs_count)
    relay_teams.includes(:relay_competitors => :relay_team).sort do |a,b|
      [last_leg ? a.no_result_reason.to_s : 0,
        a.time_in_seconds(leg) || 99999999, a.number] <=>
      [last_leg ? b.no_result_reason.to_s : 0,
        b.time_in_seconds(leg) || 99999999, b.number]
    end
  end

  def finish_errors
    errors = []
    unless start_time
      errors << 'Viestiltä puuttuu aloitusaika'
    end
    if relay_teams.empty?
      errors << 'Viestissä ei ole yhtään joukkuetta'
    end
    if relay_correct_estimates.empty?
      errors << 'Viestistä puuttuu oikeat arviot'
    end
    relay_competitors.each do |competitor|
      unless competitor.relay_team.no_result_reason
        if competitor.arrival_time.nil?
          errors << 'Osalta kilpailijoista puuttuu saapumisaika'
          break
        elsif competitor.misses.nil?
          errors << 'Osalta kilpailijoista puuttuu ohilaukausten määrä'
          break
        elsif competitor.estimate.nil?
          errors << 'Osalta kilpailijoista puuttuu arvio'
          break
        end
      end
    end
    relay_correct_estimates.each do |ce|
      if ce.distance.nil?
        errors << 'Viestistä puuttuu oikeat arviot'
      end
    end
    return errors
  end

  def finish
    fin_errors = finish_errors
    unless fin_errors.empty?
      fin_errors.each do |msg| errors.add(:base, msg) end
      return false
    end
    self.finished = true
    save!
    return true
  end

  def active?
    start_time and start_time < Time.zone.now and not race.finished
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
