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
end
