class Official::SeriesController < Official::OfficialController
  before_filter :check_series_rights

  def update
    @series = Series.find(params[:id])
    if @series.update_attributes(params[:series])
      flash[:notice] = 'Sarjan asetukset päivitetty'
      redirect_to official_series_competitors_path(@series)
    else
      render 'official/competitors/index'
    end
  end

  def check_series_rights
    series = Series.find(params[:id])
    check_race(series.race)
  end
end
