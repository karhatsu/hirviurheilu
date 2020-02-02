class QuickSave::ExtraRoundShots < QuickSave::QuickSaveBase
  def initialize(race_id, string)
    super race_id, string, /^(\+\+|)\d+(\,)[\+\*0-9]+$/
  end

  private

  def set_competitor_attrs
    return unless @competitor.shots && @competitor.shots.length >= 20
    @competitor.shots = @competitor.shots + extra_shots
  end

  def competitor_has_attrs?
    false
  end

  def extra_shots
    result_string.split('').map { |shot| parse_shot shot }
  end

  def parse_shot(shot)
    return 11 if shot == '*'
    return 10 if shot == '+'
    shot.to_i
  end

  def save_competitor
    if @competitor.shots.nil? || @competitor.shots.length < 20
      @competitor.errors.add :base, 'Loppukilpailun laukaukset puuttuvat'
      return false
    end
    @competitor.save
  end
end
