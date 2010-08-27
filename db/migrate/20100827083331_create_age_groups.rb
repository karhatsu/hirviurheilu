class CreateAgeGroups < ActiveRecord::Migration
  def self.up
    create_table :age_groups do |t|
      t.references :series, :null => false
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :age_groups
  end
end
