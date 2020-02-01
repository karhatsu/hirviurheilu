class QuickSave::UnfinishedCompetitor < QuickSave::QuickSaveBase
  def initialize(race_id, string)
    super(race_id, string, /^(\+\+|)\d+(\,|#)dns$|dnf$|dq$|DNS$|DNF$|DQ$/)
  end

  private
  def set_competitor_attrs
    @competitor.no_result_reason = result_string.upcase
  end

  def competitor_has_attrs?
    @competitor.no_result_reason
  end
end
