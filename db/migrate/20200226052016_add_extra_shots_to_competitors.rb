class AddExtraShotsToCompetitors < ActiveRecord::Migration[6.0]
  def up
    add_column :competitors, :extra_shots, :jsonb
    Race.all.where(sport_key: [Sport::ILMAHIRVI, Sport::ILMALUODIKKO]).each do |race|
      race.competitors.each do |competitor|
        if competitor.shots && competitor.shots.length > 20
          competitor.update_column :extra_shots, competitor.shots[20..-1]
          competitor.update_column :shots, competitor.shots[0...20]
        end
      end
    end
  end

  def down
    Competitor.where('extra_shots IS NOT NULL').each do |competitor|
      competitor.shots += competitors.extra_shots
      competitor.save!
    end
    remove_column :competitors, :extra_shots
  end
end
