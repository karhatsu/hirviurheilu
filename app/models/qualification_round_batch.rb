class QualificationRoundBatch < Batch
  has_many :competitors, -> { order(:qualification_round_track_place) }
end
