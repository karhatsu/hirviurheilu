class AddRifleNationalRecordToSeries < ActiveRecord::Migration[6.0]
  def change
    add_column :series, :rifle_national_record, :integer
  end
end
