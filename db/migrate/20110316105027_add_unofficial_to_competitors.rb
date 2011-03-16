class AddUnofficialToCompetitors < ActiveRecord::Migration
  def self.up
    add_column :competitors, :unofficial, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :competitors, :unofficial
  end
end
