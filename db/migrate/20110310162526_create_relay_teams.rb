class CreateRelayTeams < ActiveRecord::Migration
  def self.up
    create_table :relay_teams do |t|
      t.references :relay, :null => false
      t.string :name, :null => false
      t.integer :number, :null => false

      t.timestamps
    end

    add_index :relay_teams, :relay_id
  end

  def self.down
    drop_table :relay_teams
  end
end
