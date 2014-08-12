class AddShorterTripToAgeGroups < ActiveRecord::Migration
  def change
    add_column :age_groups, :shorter_trip, :boolean, null: false, default: false
  end
end
