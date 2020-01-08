class AddBatchFieldsToCompetitors < ActiveRecord::Migration[6.0]
  def change
    add_reference :competitors, :batch, index: true
    add_column :competitors, :track_place, :integer
  end
end
