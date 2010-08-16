class CreateCompetitors < ActiveRecord::Migration
  def self.up
    create_table :competitors do |t|
      t.references :series, :null => false
      t.references :club, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.integer :year_of_birth, :null => false
      t.integer :number
      t.time :start_time
      t.time :arrival_time
      t.integer :shot1
      t.integer :shot2
      t.integer :shot3
      t.integer :shot4
      t.integer :shot5
      t.integer :shot6
      t.integer :shot7
      t.integer :shot8
      t.integer :shot9
      t.integer :shot10
      t.integer :shots_total_input
      t.integer :estimate1
      t.integer :estimate2

      t.timestamps
    end
  end

  def self.down
    drop_table :competitors
  end
end
