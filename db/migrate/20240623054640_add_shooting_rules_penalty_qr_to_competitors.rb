class AddShootingRulesPenaltyQrToCompetitors < ActiveRecord::Migration[7.1]
  def change
    add_column :competitors, :shooting_rules_penalty_qr, :integer
  end
end
