class AddDayToBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :batches, :day, :integer, null: false, default: 1
  end
end
