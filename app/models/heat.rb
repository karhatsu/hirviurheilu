class Heat < ApplicationRecord
  belongs_to :race

  validates :type, presence: true
  validates :number, numericality: { greater_than: 0, only_integer: true, allow_nil: false }, uniqueness: { scope: [:race_id, :type] }
  validates :track, numericality: { greater_than: 0, only_integer: true, allow_nil: true }
  validates :time, presence: true, uniqueness: { scope: [:race_id, :track, :day, :type] }
  validates :day, numericality: { greater_than: 0, only_integer: true, allow_nil: false }
  validates :day2, numericality: { greater_than: 0, only_integer: true, allow_nil: true }
  validates :day3, numericality: { greater_than: 0, only_integer: true, allow_nil: true }
  validates :day4, numericality: { greater_than: 0, only_integer: true, allow_nil: true }
  validate :day_not_too_big

  def qualification_round?
    type == 'QualificationRoundHeat'
  end

  def final_round?
    type == 'FinalRoundHeat'
  end

  def save_results(results)
    errors = []
    transaction do
      results.each do |result|
        place = result[:place]
        competitor = find_competitor_by_track_place place
        if competitor
          set_competitor_shots competitor, result[:shots], errors
          unless competitor.save
            errors << "#{I18n.t('official.heat_results.competitor_save_error', track_place: place)}: #{competitor.errors.full_messages.join('. ')}"
          end
        else
          errors << I18n.t('official.heat_results.competitor_not_found', track_place: place)
        end
      end
      raise ActiveRecord::Rollback unless errors.empty?
    end
    errors
  end

  private

  def day_not_too_big
    errors.add(:day, "ei voi olla suurempi kuin kilpailupäivien määrä") if race && day > race.days_count
    errors.add(:day2, "ei voi olla suurempi kuin kilpailupäivien määrä") if race && day2 && day2 > race.days_count
    errors.add(:day3, "ei voi olla suurempi kuin kilpailupäivien määrä") if race && day3 && day3 > race.days_count
    errors.add(:day4, "ei voi olla suurempi kuin kilpailupäivien määrä") if race && day4 && day4 > race.days_count
  end
end
