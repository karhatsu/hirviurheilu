class CopyTeamCompetitionDataToNewTable < ActiveRecord::Migration
  def self.up
    Race.where('team_competitor_count > 1').each do |race|
      tc = TeamCompetition.new(:name => 'Joukkuekilpailu',
        :team_competitor_count => race.team_competitor_count)
      race.team_competitions << tc
      race.series.each do |series|
        tc.series << series
      end
    end
  end

  def self.down
    TeamCompetition.destroy_all
  end
end
