class AddShootingTimesToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :shooting_start_time, :time
    add_column :competitors, :shooting_finish_time, :time
  end
end
