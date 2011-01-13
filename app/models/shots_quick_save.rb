class ShotsQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^\d+\.\d+$/, /^\d+\.\d+\.\d+\.\d+\.\d+\.\d+\.\d+\.\d+\.\d+\.\d+\.\d+$/)
  end

  private
  def set_competitor_attrs
    values = @string.split('.')
    if values.length == 2
      @competitor.shots.clear
      @competitor.shots_total_input = values[1]
    else
      @competitor.shots.clear
      @competitor.shots_total_input = nil
      for i in 1..10
        @competitor.shots << Shot.new(:value => values[i])
      end
    end
  end
end
