class AddFinishedToRelays < ActiveRecord::Migration
  def self.up
    add_column :relays, :finished, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :relays, :finished
  end
end
