class AddUseTeamNameToTeamCompetitions < ActiveRecord::Migration
  def change
    add_column :team_competitions, :use_team_name, :boolean, :default => false, :null => false
  end
end
