class CreateRaceOfficials < ActiveRecord::Migration
  def self.up
    create_table :race_officials, :id => false do |t|
      t.references :race, :null => false
      t.references :user, :null => false
    end
  end

  def self.down
    drop_table :race_officials
  end
end
