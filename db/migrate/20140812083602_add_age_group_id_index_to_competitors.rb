class AddAgeGroupIdIndexToCompetitors < ActiveRecord::Migration
  def change
    add_index :competitors, :age_group_id
  end
end
