class AddDaysToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :day2, :integer, null: false, default: 1
    add_column :batches, :day3, :integer, null: false, default: 1
    add_column :batches, :day4, :integer, null: false, default: 1
  end
end
