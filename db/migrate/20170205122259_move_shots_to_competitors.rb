class MoveShotsToCompetitors < ActiveRecord::Migration
  def up
    10.times do |i|
      add_column :competitors, "shot_#{i}", :integer
    end
    Competitor.all.includes(:shots).each do |competitor|
      if competitor.shots.count > 0
        puts "Competitor id #{competitor.id}"
        shots = competitor.shots.map &:value
        shots.each_with_index do |shot, i|
          break if i == 10
          competitor["shot_#{i}"] = shot
        end
        competitor.save validate: false
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
