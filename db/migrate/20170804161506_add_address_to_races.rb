class AddAddressToRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :races, :address, :string
  end
end
