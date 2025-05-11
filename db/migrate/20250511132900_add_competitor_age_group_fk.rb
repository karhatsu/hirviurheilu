class AddCompetitorAgeGroupFk < ActiveRecord::Migration[8.0]
  def change
    Competitor.where(age_group_id: 0).update_all(age_group_id: nil)
    add_foreign_key :competitors, :age_groups
  end
end
