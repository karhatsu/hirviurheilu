class AddOrganizerToRaces < ActiveRecord::Migration
  def change
    add_column :races, :organizer, :string
  end
end
