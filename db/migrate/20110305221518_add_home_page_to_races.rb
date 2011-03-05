class AddHomePageToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :home_page, :string
  end

  def self.down
    remove_column :races, :home_page
  end
end
