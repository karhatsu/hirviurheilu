class CreateTeamCompetitionSeries < ActiveRecord::Migration
  def self.up
    create_table :team_competition_series, :id => false do |t|
      t.references :team_competition, :null => false
      t.references :series, :null => false

      t.timestamps
    end

    add_index :team_competition_series, :team_competition_id
  end

  def self.down
    drop_table :team_competition_series
  end
end
