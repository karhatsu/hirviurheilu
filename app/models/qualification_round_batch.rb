class QualificationRoundBatch < Batch
  has_many :competitors, -> { order(:track_place) }
end
