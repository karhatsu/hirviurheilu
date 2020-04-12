class AddNationalRecordToTeamCompetitions < ActiveRecord::Migration[6.0]
  def change
    add_column :team_competitions, :national_record, :integer
  end
end
