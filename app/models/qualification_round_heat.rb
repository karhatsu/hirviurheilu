class QualificationRoundHeat < Heat
  has_many :competitors, -> { order(:qualification_round_track_place) }

  def qualification_round?
    true
  end

  def final_round?
    false
  end

  def id_name
    :qualification_round_heat_id
  end

  private

  def find_competitor_by_track_place(place)
    competitors.where(qualification_round_track_place: place).first
  end

  def set_competitor_shots(competitor, shots, _)
    competitor.shots = shots
  end
end
