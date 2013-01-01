class AddPrimaryKeyToRaceRights < ActiveRecord::Migration
  def change
    add_column :race_rights, :id, :primary_key
  end
end
