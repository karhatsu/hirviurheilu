class DropActivationKeys < ActiveRecord::Migration[8.0]
  def change
    drop_table :activation_keys
  end
end
