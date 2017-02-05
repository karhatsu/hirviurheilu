class ShotsQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^(\+\+|)\d+\,[0-9][0-9]?0?$/, /^(\+\+|)\d+\,[\+0-9]{10}$/)
  end

  private
  def set_competitor_attrs
    if @string.length < 12
      for i in 0..9
        @competitor["shot_#{i}"] = nil
      end
      @competitor.shots_total_input = @string.split(',')[1]
    else
      shots = @string[@string.index(',') + 1, 10]
      @competitor.shots_total_input = nil
      for i in 0..9
        shot = shots[i, 1]
        shot = 10 if shot == '+'
        @competitor["shot_#{i}"] = shot
      end
    end
  end

  def competitor_has_attrs?
    !@competitor.shots.empty? ||
    !@competitor.shots_total_input.nil?
  end
end
