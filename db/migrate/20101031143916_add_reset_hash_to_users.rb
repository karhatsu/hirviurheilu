class AddResetHashToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_hash, :string
  end

  def self.down
    remove_column :users, :reset_hash
  end
end
