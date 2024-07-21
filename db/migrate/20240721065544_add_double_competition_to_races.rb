class AddDoubleCompetitionToRaces < ActiveRecord::Migration[7.1]
  def change
    add_column :races, :double_competition, :boolean, null: false, default: false
  end
end
