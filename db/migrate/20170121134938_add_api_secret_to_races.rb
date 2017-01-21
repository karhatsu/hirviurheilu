class AddApiSecretToRaces < ActiveRecord::Migration
  def change
    add_column :races, :api_secret, :string
  end
end
