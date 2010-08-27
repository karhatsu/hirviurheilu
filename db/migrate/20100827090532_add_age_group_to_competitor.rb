class AddAgeGroupToCompetitor < ActiveRecord::Migration
  def self.up
    add_column :competitors, :age_group_id, :integer
  end

  def self.down
    remove_column :competitors, :age_group_id
  end
end
