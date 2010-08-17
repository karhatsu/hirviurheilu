class CreateSeries < ActiveRecord::Migration
  def self.up
    create_table :series do |t|
      t.references :contest
      t.string :name, :null => false
      t.integer :correct_estimate1
      t.integer :correct_estimate2

      t.timestamps
    end
  end

  def self.down
    drop_table :series
  end
end
