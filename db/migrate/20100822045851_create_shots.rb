class CreateShots < ActiveRecord::Migration
  def self.up
    create_table :shots do |t|
      t.references :competitor
      t.integer :value

      t.timestamps
    end

    remove_column :competitors, :shot1
    remove_column :competitors, :shot2
    remove_column :competitors, :shot3
    remove_column :competitors, :shot4
    remove_column :competitors, :shot5
    remove_column :competitors, :shot6
    remove_column :competitors, :shot7
    remove_column :competitors, :shot8
    remove_column :competitors, :shot9
    remove_column :competitors, :shot10
  end

  def self.down
    drop_table :shots

    add_column :competitors, :shot1, :integer
    add_column :competitors, :shot2, :integer
    add_column :competitors, :shot3, :integer
    add_column :competitors, :shot4, :integer
    add_column :competitors, :shot5, :integer
    add_column :competitors, :shot6, :integer
    add_column :competitors, :shot7, :integer
    add_column :competitors, :shot8, :integer
    add_column :competitors, :shot9, :integer
    add_column :competitors, :shot10, :integer
  end
end
