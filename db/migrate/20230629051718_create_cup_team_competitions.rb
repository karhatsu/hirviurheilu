class CreateCupTeamCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :cup_team_competitions do |t|
      t.references :cup, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
