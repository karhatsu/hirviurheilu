class AddShowPartialTeamsToTeamCompetitions < ActiveRecord::Migration[8.0]
  def change
    add_column :team_competitions, :show_partial_teams, :boolean, null: false, default: false
  end
end
