class AddShootingOvertimeMinToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :shooting_overtime_min, :integer
  end
end
