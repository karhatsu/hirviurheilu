class FinalRoundBatch < Batch
  has_many :competitors, -> { order(:final_round_track_place) }

  def qualification_round?
    false
  end

  def final_round?
    true
  end
end
