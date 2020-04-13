class QuickSave::FinalRoundShots < QuickSave::QuickSaveBase
  def initialize(race_id, string)
    super race_id, string, /^(\+\+|)\d+(\,)[0-9][0-9]?0?$/, /^(\+\+|)\d+(\,)[\+\*0-9]{5}$/, /^(\+\+|)\d+(\,)[\+\*0-9]{10}$/
  end

  private

  def set_competitor_attrs
    if sum_input?
      @competitor.shots = nil
      @competitor.final_round_shooting_score_input = result_string
    else
      return unless @competitor.shots && @competitor.shots.length >= 10
      qualification_shots = @competitor.shots[0..9]
      @competitor.shots = qualification_shots + final_shots
    end
  end

  def competitor_has_attrs?
    return @competitor.final_round_shooting_score_input if sum_input?
    @competitor.shots && @competitor.shots.length == 20
  end

  def final_shots
    result_string.split('').map { |shot| parse_shot shot }
  end

  def save_competitor
    if sum_input? && !@competitor.qualification_round_shooting_score_input
      @competitor.errors.add :base, 'Alkukilpailun tulos puuttuu'
      return false
    elsif !sum_input? && (@competitor.shots.nil? || @competitor.shots.length < 10)
      @competitor.errors.add :base, 'Alkukilpailun tulos puuttuu'
      return false
    end
    @competitor.save
  end

  def sum_input?
    @string.length < 7
  end
end
