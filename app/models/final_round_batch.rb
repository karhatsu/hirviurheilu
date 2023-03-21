class FinalRoundBatch < Batch
  has_many :competitors, -> { order(:final_round_track_place) }

  def qualification_round?
    false
  end

  def final_round?
    true
  end

  def id_name
    :final_round_batch_id
  end

  private

  def find_competitor_by_track_place(place)
    competitors.where(final_round_track_place: place).first
  end

  def set_competitor_shots(competitor, shots, errors)
    if !competitor.shots || competitor.shots.length < competitor.sport.qualification_round_shot_count
      errors << I18n.t('official.batch_results.no_qualification_round_shots', track_place: competitor.final_round_track_place)
    else
      competitor.shots = competitor.qualification_round_shots.flatten + shots
    end
  end
end
