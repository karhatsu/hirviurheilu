class Event < ApplicationRecord
  has_many :races, -> { order(:start_date) }

  validates :name, presence: true
end
