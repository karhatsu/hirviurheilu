class RemoveColumnsFromJoinTables < ActiveRecord::Migration
  def self.up
    remove_column :rights, :created_at
    remove_column :rights, :updated_at
    rename_table :team_competition_age_groups, :temp_table  # sqlite3 problem workaround
    remove_column :temp_table, :created_at
    remove_column :temp_table, :updated_at
    rename_table :temp_table, :team_competition_age_groups
    rename_table :team_competition_series, :temp_table  # sqlite3 problem workaround
    remove_column :temp_table, :created_at
    remove_column :temp_table, :updated_at
    rename_table :temp_table, :team_competition_series
  end

  def self.down
    add_column :rights, :created_at, :datetime
    add_column :rights, :updated_at, :datetime
    add_column :team_competition_age_groups, :created_at, :datetime
    add_column :team_competition_age_groups, :updated_at, :datetime
    add_column :team_competition_series, :created_at, :datetime
    add_column :team_competition_series, :updated_at, :datetime
  end
end
