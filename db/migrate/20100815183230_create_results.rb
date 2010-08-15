class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.references :competitor
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
