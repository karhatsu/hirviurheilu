class AddPrimaryToRaceRights < ActiveRecord::Migration
  def up
    add_column :race_rights, :primary, :boolean, null: false, default: false
    Race.all.each do |race|
      rr = race.race_rights.first
      rr.primary = true
      rr.save!
    end
  end

  def down
    remove_column :race_rights, :primary
  end
end
