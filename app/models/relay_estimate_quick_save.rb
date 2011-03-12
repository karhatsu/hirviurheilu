class RelayEstimateQuickSave < RelayQuickSave
  def initialize(relay_id, string)
    super(relay_id, string, /^\d+,\d+,\d+$/)
  end

  private
  def set_competitor_attrs
    @competitor.estimate = @string.split(',')[2]
  end
end
