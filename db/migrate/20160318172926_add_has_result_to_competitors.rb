class AddHasResultToCompetitors < ActiveRecord::Migration
  def up
    add_column :competitors, :has_result, :boolean, null: false, default: false
    Competitor.where('arrival_time is not null or estimate1 is not null or shots_total_input is not null')
        .update_all("has_result=#{DatabaseHelper.true_value}")
  end

  def down
    remove_column :competitors, :has_result
  end
end
