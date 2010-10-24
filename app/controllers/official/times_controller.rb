class Official::TimesController < Official::OfficialController
  before_filter :check_race_rights, :except => :change_series
  before_filter :set_times

  def index
    @series = Series.find(params[:series_id])
  end

  def change_series
    redirect_to official_series_times_path(params[:series_id])
  end

  private
  def check_race_rights
    check_race(Series.find(params[:series_id]).race)
  end

  def set_times
    @is_times = true
  end
end
