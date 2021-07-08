class QuickSave::QualificationRoundShots < QuickSave::QuickSaveBase
  def initialize(race_id, string, shot_count)
    super race_id, string, /^(\+\+|)\d+(\,)[0-9]{1,3}$/, /^(\+\+|)\d+(\,)[\+\*0-9]{#{shot_count}}$/
  end

  private
  def set_competitor_attrs
    if @string.length < 12
      @competitor.shots = nil
      @competitor.qualification_round_shooting_score_input = result_string
    else
      final_shots = @competitor.shots ? @competitor.shots[10..-1] || [] : []
      @competitor.shots = qualification_shots + final_shots
    end
  end

  def competitor_has_attrs?
    @competitor.shots || @competitor.qualification_round_shooting_score_input
  end

  def qualification_shots
    result_string.split('').map { |shot| parse_shot shot }
  end
end
