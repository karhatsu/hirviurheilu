class AddExtraTimesToBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :batches, :time2, :time
    add_column :batches, :time3, :time
    add_column :batches, :time4, :time
  end
end
