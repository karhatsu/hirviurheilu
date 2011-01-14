class AddTeamCompetitorCountToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :team_competitor_count, :integer
  end

  def self.down
    remove_column :races, :team_competitor_count
  end
end
