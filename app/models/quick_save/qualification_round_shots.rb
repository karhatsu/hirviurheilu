class QuickSave::QualificationRoundShots < QuickSave::QuickSaveBase
  def initialize(race_id, string)
    super race_id, string, /^(\+\+|)\d+(\,)[\+\*0-9]{10}$/
  end

  private
  def set_competitor_attrs
    final_shots = @competitor.shots ? @competitor.shots[10..-1] || [] : []
    @competitor.shots = qualification_shots + final_shots
  end

  def competitor_has_attrs?
    @competitor.shots
  end

  def qualification_shots
    result_string.split('').map { |shot| parse_shot shot }
  end

  def parse_shot(shot)
    return 11 if shot == '*'
    return 10 if shot == '+'
    shot.to_i
  end
end
