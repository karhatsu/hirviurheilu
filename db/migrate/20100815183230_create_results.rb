class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.references :competitor
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
      t.time :arrival

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
