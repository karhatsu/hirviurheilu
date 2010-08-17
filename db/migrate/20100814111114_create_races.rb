class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
      t.references :sport, :null => false
      t.string :name, :null => false
      t.string :location, :null => false
      t.date :start_date, :null => false
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :races
  end
end
