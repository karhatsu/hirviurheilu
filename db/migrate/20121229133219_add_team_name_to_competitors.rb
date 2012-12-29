class AddTeamNameToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :team_name, :string
  end
end
