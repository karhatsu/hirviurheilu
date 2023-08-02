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
    if @competitor.qualification_round_shooting_score_input
      @competitor.save
    elsif @competitor.shots.nil? || @competitor.shots.length < @competitor.sport.qualification_round_shot_count
      @competitor.errors.add :base, 'Alkukilpailun tulos puuttuu'
      return false
    elsif @competitor.shots.length > @competitor.sport.qualification_round_shot_count && @competitor.shots.length < @competitor.sport.shot_count
      @competitor.errors.add :base, 'Loppukilpailun tulos puuttuu'
      return false
    else
      @competitor.save
    end
  end
end
