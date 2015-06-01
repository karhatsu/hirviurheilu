class AddBillingInfoToRaces < ActiveRecord::Migration
  def change
    add_column :races, :billing_info, :string
  end
end
