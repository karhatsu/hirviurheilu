class AddActivationKeyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_key, :string
  end

  def self.down
    remove_column :users, :activation_key
  end
end
