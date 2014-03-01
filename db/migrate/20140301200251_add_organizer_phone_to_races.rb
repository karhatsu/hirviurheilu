class AddOrganizerPhoneToRaces < ActiveRecord::Migration
  def change
    add_column :races, :organizer_phone, :string
  end
end
