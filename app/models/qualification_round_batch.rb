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
end
