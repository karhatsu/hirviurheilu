class RemoveColumnsFromJoinTables < ActiveRecord::Migration
  def self.up
    remove_column :rights, :created_at
    remove_column :rights, :updated_at
    remove_column :team_competition_age_groups, :created_at
    remove_column :team_competition_age_groups, :updated_at
    remove_column :team_competition_series, :created_at
    remove_column :team_competition_series, :updated_at
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
