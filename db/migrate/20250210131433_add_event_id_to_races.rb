class AddEventIdToRaces < ActiveRecord::Migration[8.0]
  def change
    add_reference :races, :event, foreign_key: true
  end
end
