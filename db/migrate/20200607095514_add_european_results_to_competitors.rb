class AddEuropeanResultsToCompetitors < ActiveRecord::Migration[6.0]
  def change
    add_column :competitors, :european_results, :jsonb
  end
end
