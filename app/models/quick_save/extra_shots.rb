class QuickSave::ExtraShots < QuickSave::QuickSaveBase
  def initialize(race_id, string)
    super race_id, string, /^(\+\+|)\d+(\,)[\+\*0-9]+$/
  end

  private

  def set_competitor_attrs
    @competitor.extra_shots = (@competitor.extra_shots || []) + extra_shots
  end

  def competitor_has_attrs?
    false
  end

  def extra_shots
    result_string.split('').map { |shot| parse_shot shot }
  end

  def save_competitor
    if !@competitor.final_round_shooting_score_input && (@competitor.shots.nil? || @competitor.shots.length < @competitor.sport.shot_count)
      @competitor.errors.add :base, 'Loppukilpailun tulos puuttuu'
      return false
    end
    @competitor.save
  end
end
