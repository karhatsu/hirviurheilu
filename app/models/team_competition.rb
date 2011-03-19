class TeamCompetition < ActiveRecord::Base
  belongs_to :race
  has_and_belongs_to_many :series, :join_table => 'team_competition_series'
  has_and_belongs_to_many :age_groups, :join_table => 'team_competition_age_groups'

  validates :name, :presence => true
  validates :team_competitor_count, :numericality => { :only_integer => true,
    :greater_than => 1 }
end
