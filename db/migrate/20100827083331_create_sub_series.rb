class CreateSubSeries < ActiveRecord::Migration
  def self.up
    create_table :sub_series do |t|
      t.references :series, :null => false
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :sub_series
  end
end
