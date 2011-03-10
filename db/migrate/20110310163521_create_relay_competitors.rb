class CreateRelayCompetitors < ActiveRecord::Migration
  def self.up
    create_table :relay_competitors do |t|
      t.references :relay_team, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.integer :leg, :null => false
      t.time :start_time
      t.time :arrival_time
      t.integer :misses
      t.integer :estimate

      t.timestamps
    end

    add_index :relay_competitors, :relay_team_id
  end

  def self.down
    drop_table :relay_competitors
  end
end
