class RemoveYearOfBirthFromCompetitor < ActiveRecord::Migration
  def self.up
    remove_column :competitors, :year_of_birth
  end

  def self.down
    add_column :competitors, :year_of_birth, :integer
  end
end
