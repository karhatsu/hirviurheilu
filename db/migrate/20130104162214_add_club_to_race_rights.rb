class AddClubToRaceRights < ActiveRecord::Migration
  def change
    add_column :race_rights, :club_id, :integer
  end
end
