class MoveShotsToCompetitors < ActiveRecord::Migration
  def up
    10.times do |i|
      add_column :competitors, "shot_#{i}", :integer
    end
    Competitor.all.each do |competitor|
      shots = Shot.where(competitor_id: competitor.id).order('value desc').map &:value
      if shots.count > 0
        puts "Competitor id #{competitor.id}"
        shots.each_with_index do |shot, i|
          break if i == 10
          competitor["shot_#{i}"] = shot
        end
        competitor.save validate: false
      end
    end
  end

  def down
    10.times do |i|
      remove_column :competitors, "shot_#{i}"
    end
  end
end
