class RelayQuickSave::Estimate < RelayQuickSave::RelayQuickSaveBase
  def initialize(relay_id, string)
    super(relay_id, string, /^(\+\+)?\d+,\d+,\d+$/)
  end

  private
  def competitor_has_attrs?
    !@competitor.estimate.nil?
  end

  def set_competitor_attrs
    @competitor.estimate = @string.split(',')[2]
  end
end
