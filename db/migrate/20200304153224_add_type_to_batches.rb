class AddTypeToBatches < ActiveRecord::Migration[6.0]
  def up
    add_column :batches, :type, :string, null: false, default: 'QualificationRoundBatch'
    change_column :batches, :type, :string, default: nil
  end

  def down
    remove_column :batches, :type
  end
end
