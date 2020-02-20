class DropPriceTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :base_prices
    drop_table :prices
  end
end
