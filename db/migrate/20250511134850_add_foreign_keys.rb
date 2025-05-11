class AddForeignKeys < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :age_groups, :series
    add_foreign_key :clubs, :races
    add_foreign_key :competitors, :clubs
    add_foreign_key :competitors, :series
    add_foreign_key :correct_estimates, :races
    add_foreign_key :cup_officials, :cups
    add_foreign_key :cup_officials, :users
    add_foreign_key :cup_series, :cups
    add_foreign_key :cups_races, :cups
    add_foreign_key :cups_races, :races
    add_foreign_key :relay_competitors, :relay_teams
    add_foreign_key :relay_correct_estimates, :relays
    add_foreign_key :relay_teams, :relays
    add_foreign_key :relays, :races
    add_foreign_key :series, :races
    add_foreign_key :team_competitions, :races
  end
end
