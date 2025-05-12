class AddMoreForeignKeys < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :race_rights, :races
    add_foreign_key :race_rights, :users
    add_foreign_key :rights, :roles
    add_foreign_key :rights, :users
    add_foreign_key :team_competition_age_groups, :age_groups
    add_foreign_key :team_competition_age_groups, :team_competitions
    add_foreign_key :team_competition_series, :series
    add_foreign_key :team_competition_series, :team_competitions
  end
end
