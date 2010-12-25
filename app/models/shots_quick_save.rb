class ShotsQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^\d+:\d+$/)
  end

  private
  def save_result
    @competitor.shots_total_input = @string.split(':')[1]
    @competitor.save!
  end
end
