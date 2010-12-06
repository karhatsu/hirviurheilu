class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.integer :min_competitors, :null => false, :default => 0
      t.decimal :price, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
