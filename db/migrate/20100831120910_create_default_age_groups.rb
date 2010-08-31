class CreateDefaultAgeGroups < ActiveRecord::Migration
  def self.up
    create_table :default_age_groups do |t|
      t.references :default_series, :null => false
      t.string :name, :null => false
      t.integer :min_competitors, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :default_age_groups
  end
end
