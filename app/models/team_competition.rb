class TeamCompetition < ActiveRecord::Base
  belongs_to :race

  validates :name, :presence => true
  validates :team_competitor_count, :numericality => { :only_integer => true,
    :greater_than => 1 }
end
