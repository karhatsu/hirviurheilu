class AddNewClubsToRaceRights < ActiveRecord::Migration
  def change
    add_column :race_rights, :new_clubs, :boolean, null: false, default: false
  end
end
