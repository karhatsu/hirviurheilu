class AddMultipleTeamsToTeamCompetitions < ActiveRecord::Migration
  def change
    add_column :team_competitions, :multiple_teams, :boolean, null: false, default: false
  end
end
