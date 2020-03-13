class FinalRoundBatch < Batch
  has_many :competitors, -> { order(:track_place) }
end
