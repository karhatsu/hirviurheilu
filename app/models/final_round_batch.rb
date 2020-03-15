class FinalRoundBatch < Batch
  has_many :competitors, -> { order(:final_round_track_place) }
end
