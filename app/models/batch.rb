class Batch < ApplicationRecord
  belongs_to :race

  validates :number, numericality: { greater_than: 0, only_integer: true, allow_nil: false }
  validates :track, numericality: { greater_than: 0, only_integer: true, allow_nil: false }
  validates :time, presence: true
end
