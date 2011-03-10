class CreateRelays < ActiveRecord::Migration
  def self.up
    create_table :relays do |t|
      t.references :race, :null => false
      t.integer :start_day, :null => false
      t.time :start_time
      t.string :name, :null => false
      t.integer :legs, :null => false

      t.timestamps
    end

    add_index :relays, :race_id
  end

  def self.down
    drop_table :relays
  end
end
