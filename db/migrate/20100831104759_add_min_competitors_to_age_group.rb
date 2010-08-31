class AddMinCompetitorsToAgeGroup < ActiveRecord::Migration
  def self.up
    add_column :age_groups, :min_competitors, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :age_groups, :min_competitors
  end
end
