class Official::EstimatesController < Official::OfficialController
  before_action :assign_series_by_series_id, :check_assigned_series, :set_estimates

  def index
  end

  private
  def set_estimates
    @is_estimates = true
  end
end
