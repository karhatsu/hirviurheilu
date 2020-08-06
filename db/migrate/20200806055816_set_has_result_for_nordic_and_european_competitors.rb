class SetHasResultForNordicAndEuropeanCompetitors < ActiveRecord::Migration[6.0]
  def up
    Race.where("sport_key = 'NORDIC'").each do |race|
      race.competitors.each do |competitor|
        competitor.update_attribute :has_result, true if competitor.nordic_score
      end
    end
    Race.where("sport_key = 'EUROPEAN'").each do |race|
      race.competitors.each do |competitor|
        competitor.update_attribute :has_result, true if competitor.european_score
      end
    end
  end

  def down
  end
end
