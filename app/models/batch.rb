class Batch < ApplicationRecord
  belongs_to :race
  has_many :competitors, -> { order(:track_place) }

  validates :number, numericality: { greater_than: 0, only_integer: true, allow_nil: false }, uniqueness: { scope: :race_id }
  validates :track, numericality: { greater_than: 0, only_integer: true, allow_nil: true }
  validates :time, presence: true, uniqueness: { scope: [:race_id, :track, :day] }
  validates :day, numericality: { greater_than: 0, only_integer: true, allow_nil: false }
  validate :day_not_too_big

  private

  def day_not_too_big
    errors.add(:day, "ei voi olla suurempi kuin kilpailupäivien määrä") if race && day > race.days_count
  end
end
