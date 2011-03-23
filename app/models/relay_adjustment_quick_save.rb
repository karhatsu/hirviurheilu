class RelayAdjustmentQuickSave < RelayQuickSave
  def initialize(relay_id, string)
    super(relay_id, string, /^\d+,\d+,(\+|-|)\d+$/)
  end

  def set_competitor_attrs
    @competitor.adjustment = @string.split(',')[2]
  end
end
