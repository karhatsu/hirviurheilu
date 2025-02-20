class Event < ApplicationRecord
  has_many :races

  validates :name, presence: true
end
