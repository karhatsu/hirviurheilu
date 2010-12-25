class EstimatesQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^\d+:\d+:\d+$/)
  end

  private
  def save_result
    numbers = @string.split(':')
    @competitor.estimate1 = numbers[1]
    @competitor.estimate2 = numbers[2]
    @competitor.save!
  end
end
