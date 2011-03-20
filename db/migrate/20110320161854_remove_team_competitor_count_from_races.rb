class RemoveTeamCompetitorCountFromRaces < ActiveRecord::Migration
  def self.up
    remove_column :races, :team_competitor_count
  end

  def self.down
    add_column :races, :team_competitor_count, :integer
  end
end
