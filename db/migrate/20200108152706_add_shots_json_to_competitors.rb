class AddShotsJsonToCompetitors < ActiveRecord::Migration[6.0]
  def up
    add_column :competitors, :shots, :jsonb
    Competitor.where('shot_0 is not null').each do |competitor|
      shots = (0..9).to_a.map {|i| competitor["shot_#{i}"] || 0}.sort {|a, b| b.to_i <=> a.to_i}
      competitor.update_column :shots, shots
    end
  end

  def down
    remove_column :competitors, :shots
  end
end
