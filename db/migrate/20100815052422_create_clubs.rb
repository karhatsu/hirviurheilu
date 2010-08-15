class CreateClubs < ActiveRecord::Migration
  def self.up
    create_table :clubs do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :clubs
  end
end
