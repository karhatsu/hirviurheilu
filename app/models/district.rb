class District < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :short_name, presence: true, uniqueness: true
end
