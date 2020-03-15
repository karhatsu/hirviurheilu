class QualificationRoundBatch < Batch
  has_many :competitors, -> { order(:qualification_round_track_place) }

  def qualification_round?
    true
  end

  def final_round?
    false
  end
end
