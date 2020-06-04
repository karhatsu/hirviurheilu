class Official::NordicRaceShotsController < Official::OfficialController
  before_action :assign_series_by_series_id, :check_assigned_series

  def trap
    @sub_sport = :trap
    @is_trap = true
    render :index
  end
end
