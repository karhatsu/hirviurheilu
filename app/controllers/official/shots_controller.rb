class Official::ShotsController < Official::OfficialController
  before_filter :assign_series_by_series_id, :check_assigned_series, :set_shots

  def index
  end

  private
  def set_shots
    @is_shots = true
  end
end
