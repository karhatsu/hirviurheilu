class AddLongnameToClubs < ActiveRecord::Migration
  def self.up
    add_column :clubs, :longname, :string
  end

  def self.down
    remove_column :clubs, :longname
  end
end
