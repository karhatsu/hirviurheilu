class Official::EstimatesController < Official::OfficialController
  before_action :assign_series_by_series_id, :check_assigned_series, :require_three_sports_race, :set_estimates

  def index
  end

  private
  def set_estimates
    @is_estimates = true
  end
end
