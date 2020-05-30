class AddNordicResultsToCompetitors < ActiveRecord::Migration[6.0]
  def change
    add_column :competitors, :nordic_results, :jsonb
  end
end
