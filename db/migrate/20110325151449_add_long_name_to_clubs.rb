class AddLongNameToClubs < ActiveRecord::Migration
  def self.up
    add_column :clubs, :long_name, :string
  end

  def self.down
    remove_column :clubs, :long_name
  end
end
