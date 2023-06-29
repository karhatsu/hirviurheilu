class CupTeamCompetition < ApplicationRecord
  belongs_to :cup

  validates :name, presence: true
end
