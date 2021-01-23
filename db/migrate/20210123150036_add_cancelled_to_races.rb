class AddCancelledToRaces < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :cancelled, :boolean, default: false, null: false
  end
end
