class CreateTeamCompetitionAgeGroups < ActiveRecord::Migration
  def self.up
    create_table :team_competition_age_groups, :id => false do |t|
      t.references :team_competition, :null => false
      t.references :age_group, :null => false

      t.timestamps
    end

    add_index :team_competition_age_groups, :team_competition_id
  end

  def self.down
    drop_table :team_competition_age_groups
  end
end
