class CreateTeamCompetitions < ActiveRecord::Migration
  def self.up
    create_table :team_competitions do |t|
      t.references :race, :null => false
      t.string :name, :null => false
      t.integer :team_competitor_count, :null => false

      t.timestamps
    end

    add_index :team_competitions, :race_id
  end

  def self.down
    drop_table :team_competitions
  end
end
