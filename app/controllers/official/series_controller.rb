class Official::SeriesController < Official::OfficialController
  before_filter :assign_series, :check_series_rights

  def destroy
    @series.destroy
    redirect_to official_race_path(@series.race)
  end

  private
  def assign_series
    @series = Series.find(params[:id])
  end

  def check_series_rights
    check_race(@series.race)
  end
end
