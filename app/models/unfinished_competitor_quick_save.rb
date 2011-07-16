class UnfinishedCompetitorQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^(\+\+|)\d+\,dns|dnf|DNS|DNF$/)
  end

  private
  def set_competitor_attrs
    @competitor.no_result_reason = @string.split(',')[1].upcase
  end

  def competitor_has_attrs?
    @competitor.no_result_reason
  end
end
