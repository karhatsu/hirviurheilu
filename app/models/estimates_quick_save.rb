class EstimatesQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^\d+:\d+:\d+$/)
  end

  private
  def set_competitor_attrs
    numbers = @string.split(':')
    @competitor.estimate1 = numbers[1]
    @competitor.estimate2 = numbers[2]
  end
end
