class AddShorterTripToSeries < ActiveRecord::Migration[5.1]
  def change
    add_column :series, :shorter_trip, :boolean, null: false, default: false
  end
end
