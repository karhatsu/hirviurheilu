class AllowNullForBatchTrack < ActiveRecord::Migration[6.0]
  def change
    change_column :batches, :track, :integer, null: true
  end
end
