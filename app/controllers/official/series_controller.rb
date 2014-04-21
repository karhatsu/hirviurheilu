class Official::SeriesController < Official::OfficialController
  before_action :assign_series_by_id, :check_assigned_series

  def destroy
    @series.destroy
    redirect_to official_race_path(@series.race)
  end
end
