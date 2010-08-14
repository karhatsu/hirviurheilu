class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.references :sport, :null => false
      t.string :name, :null => false
      t.string :location, :null => false
      t.date :start_date, :null => false
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
