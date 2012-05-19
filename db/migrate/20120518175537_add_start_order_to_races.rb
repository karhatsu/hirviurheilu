class AddStartOrderToRaces < ActiveRecord::Migration
  def change
    add_column :races, :start_order, :integer, :null => false, :default => Race::START_ORDER_BY_SERIES
  end
end
