class AddFkToRaceRightsClubId < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :race_rights, :clubs
  end
end
