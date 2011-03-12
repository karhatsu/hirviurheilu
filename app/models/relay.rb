class Relay < ActiveRecord::Base
  belongs_to :race
  has_many :relay_teams
  has_many :relay_correct_estimates

  validates :name, :presence => true
  validates :legs_count, :numericality => { :only_integer => true, :greater_than => 1 }
  validates :start_day, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validate :start_day_not_bigger_than_race_days_count

  attr_readonly :legs_count

  accepts_nested_attributes_for :relay_teams

  private
  def start_day_not_bigger_than_race_days_count
    if race and start_day > race.days_count
      errors.add(:start_day, "ei voi olla suurempi kuin kilpailupäivien määrä")
    end
  end
end
