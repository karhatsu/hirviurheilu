class AddOnlyAddCompetitorsToRaceRights < ActiveRecord::Migration
  def change
    add_column :race_rights, :only_add_competitors, :boolean, :default => false, :null => false
  end
end
