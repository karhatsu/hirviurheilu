class RaceRight < ActiveRecord::Base
  belongs_to :user
  belongs_to :race
  belongs_to :club
end