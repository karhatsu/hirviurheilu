class AddShotsSumsForShootingRaces < ActiveRecord::Migration[6.0]
  def change
    add_column :competitors, :qualification_round_shooting_score_input, :integer
    add_column :competitors, :final_round_shooting_score_input, :integer
  end
end
