class ShotsQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^(\+\+|)\d+(\,|#)[0-9][0-9]?0?$/, /^(\+\+|)\d+(\,|#)[\+\*0-9]{10}$/)
  end

  private
  def set_competitor_attrs
    if @string.length < 12
      @competitor.shots = nil
      @competitor.shooting_score_input = result_string
    else
      shots = result_string
      @competitor.shooting_score_input = nil
      @competitor.shots = (0..9).map do |i|
        shot = shots[i, 1]
        shot = 10 if shot == '+' || shot == '*'
        shot
      end
    end
  end

  def competitor_has_attrs?
    @competitor.shots || !@competitor.shooting_score_input.nil?
  end
end
