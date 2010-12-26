class CreateBasePrices < ActiveRecord::Migration
  def self.up
    create_table :base_prices do |t|
      t.integer :price, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :base_prices
  end
end
