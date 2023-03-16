class QualificationRoundBatch < Batch
  has_many :competitors, -> { order(:qualification_round_track_place) }

  def qualification_round?
    true
  end

  def final_round?
    false
  end

  def id_name
    :qualification_round_batch_id
  end

  def save_results(results)
    errors = []
    transaction do
      results.each do |result|
        place = result[:place]
        competitor = competitors.where(qualification_round_track_place: place).first
        if competitor
          competitor.shots = result[:shots]
          unless competitor.save
            errors << "#{I18n.t('official.qualification_round_batch_results.competitor_save_error', track_place: place)}: #{competitor.errors.full_messages.join('. ')}"
          end
        else
          errors << I18n.t('official.qualification_round_batch_results.competitor_not_found', track_place: place)
        end
      end
      raise ActiveRecord::Rollback unless errors.empty?
    end
    errors
  end
end
