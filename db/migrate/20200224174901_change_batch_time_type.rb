class ChangeBatchTimeType < ActiveRecord::Migration[6.0]
  def up
    change_column :batches, :time, :time
  end

  def down
    change_column :batches, :time, :datetime
  end
end
