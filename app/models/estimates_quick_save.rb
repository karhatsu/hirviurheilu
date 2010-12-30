class EstimatesQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^\d+:\d+:\d+$/, /^\d+:\d+:\d+:\d+:\d+$/)
  end

  private
  def set_competitor_attrs
    numbers = @string.split(':')
    @competitor.estimate1 = numbers[1]
    @competitor.estimate2 = numbers[2]
    @competitor.estimate3 = numbers[3] # can be nil
    @competitor.estimate4 = numbers[4] # can be nil
  end
end
