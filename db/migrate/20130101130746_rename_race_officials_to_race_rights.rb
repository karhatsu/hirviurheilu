class RenameRaceOfficialsToRaceRights < ActiveRecord::Migration
  def change
    rename_table :race_officials, :race_rights
  end
end
