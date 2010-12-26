class ShotsQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^\d+:\d+$/)
  end

  private
  def set_competitor_attrs
    @competitor.shots_total_input = @string.split(':')[1]
  end
end
