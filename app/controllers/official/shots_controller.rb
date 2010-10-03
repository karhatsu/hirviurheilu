class Official::ShotsController < Official::OfficialController
  before_filter :check_race_rights, :except => :change_series

  def index
    @series = Series.find(params[:series_id])
  end

  def change_series
    redirect_to official_series_shots_path(params[:series_id])
  end

  private
  def check_race_rights
    check_race(Series.find(params[:series_id]).race)
  end
end
