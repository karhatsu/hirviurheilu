class Batch < ApplicationRecord
  belongs_to :race
  has_many :competitors, -> { order(:track_place) }

  validates :number, numericality: { greater_than: 0, only_integer: true, allow_nil: false }, uniqueness: { scope: :race_id }
  validates :track, numericality: { greater_than: 0, only_integer: true, allow_nil: true }
  validates :time, presence: true
end
