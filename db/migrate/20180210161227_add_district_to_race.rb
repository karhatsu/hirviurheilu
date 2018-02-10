class AddDistrictToRace < ActiveRecord::Migration[5.1]
  def change
    add_column :races, :district_id, :integer
  end
end
