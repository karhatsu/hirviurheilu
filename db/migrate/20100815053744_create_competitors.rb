class CreateCompetitors < ActiveRecord::Migration
  def self.up
    create_table :competitors do |t|
      t.references :club, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.integer :year_of_birth, :null => false
      t.integer :number
      t.time :start_time

      t.timestamps
    end
  end

  def self.down
    drop_table :competitors
  end
end
