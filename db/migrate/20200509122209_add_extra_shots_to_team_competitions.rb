class AddExtraShotsToTeamCompetitions < ActiveRecord::Migration[6.0]
  def change
    add_column :team_competitions, :extra_shots, :jsonb
  end
end
