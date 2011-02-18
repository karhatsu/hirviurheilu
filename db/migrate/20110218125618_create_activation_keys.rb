class CreateActivationKeys < ActiveRecord::Migration
  def self.up
    create_table :activation_keys do |t|
      t.string :comment, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :activation_keys
  end
end
