require 'time_helper.rb'

class Relay < ApplicationRecord
  include TimeHelper

  belongs_to :race
  has_many :relay_teams, -> { order :number }, :dependent => :destroy
  has_many :relay_correct_estimates, -> { order :leg }

  has_many :relay_competitors, :through => :relay_teams

  validates :name, :presence => true
  validates :legs_count, :numericality => { :only_integer => true, :greater_than => 1 }
  validates :start_day, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validates :leg_distance, numericality: { allow_nil: true, greater_than: 0, only_integer: true }
  validates :estimate_penalty_distance, numericality: { allow_nil: true, greater_than: 0, only_integer: true }
  validates :shooting_penalty_distance, numericality: { allow_nil: true, greater_than: 0, only_integer: true }
  validates :estimate_penalty_seconds, numericality: { allow_nil: true, greater_than: 0, only_integer: true }
  validates :shooting_penalty_seconds, numericality: { allow_nil: true, greater_than: 0, only_integer: true }
  validate :start_day_not_bigger_than_race_days_count

  attr_readonly :legs_count

  accepts_nested_attributes_for :relay_teams, :allow_destroy => true
  accepts_nested_attributes_for :relay_correct_estimates

  after_touch :publish_update

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
    leg = leg.to_i
    first_leg = (leg == 1)
    second_leg = (leg == 2)
    third_leg = (leg == 3)
    last_leg = (leg == legs_count)
    with_penalty_seconds = penalty_seconds?
    relay_teams.includes(:relay_competitors => :relay_team).sort do |a,b|
      [last_leg ? a.no_result_reason.to_s : 0,
        a.time_in_seconds(leg, with_penalty_seconds) || 99999999,
        first_leg ? 1 : a.time_in_seconds(leg - 1, with_penalty_seconds) || 99999999,
        second_leg ? 1 : a.time_in_seconds(leg - 2, with_penalty_seconds) || 99999999,
        third_leg ? 1 : a.time_in_seconds(leg - 3, with_penalty_seconds) || 99999999,
        a.number] <=>
      [last_leg ? b.no_result_reason.to_s : 0,
        b.time_in_seconds(leg, with_penalty_seconds) || 99999999,
        first_leg ? 1 : b.time_in_seconds(leg - 1, with_penalty_seconds) || 99999999,
        second_leg ? 1 : b.time_in_seconds(leg - 2, with_penalty_seconds) || 99999999,
        third_leg ? 1 : b.time_in_seconds(leg - 3, with_penalty_seconds) || 99999999,
        b.number]
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

  def can_finish?
    finish_errors.empty?
  end

  def finish
    fin_errors = finish_errors
    unless fin_errors.empty?
      fin_errors.each do |msg| errors.add(:base, msg) end
      return false
    end
    self.finished = true
    save!
    publish_update
    return true
  end

  def active?
    !finished and started?
  end

  def started?
    start_time and start_datetime < Time.zone.now
  end

  def today?
    race.race_day == start_day
  end

  def start_datetime
    return nil unless start_time and race and race.start_date
    time = Time.zone.local(race.start_date.year, race.start_date.month,
      race.start_date.day, start_time.hour, start_time.min, start_time.sec)
    time.advance(:days => start_day - 1)
  end

  def finish!
    finish || raise(errors.full_messages.to_s)
  end

  def start_time_defined?
    start_time && start_time.strftime('%H:%M') != '00:00'
  end

  def penalty_seconds?
    estimate_penalty_seconds && shooting_penalty_seconds
  end

  private
  def start_day_not_bigger_than_race_days_count
    if race and start_day > race.days_count
      errors.add(:start_day, "ei voi olla suurempi kuin kilpailupäivien määrä")
    end
  end

  def publish_update
    RelayChannel.broadcast_to self, {}
  end
end
