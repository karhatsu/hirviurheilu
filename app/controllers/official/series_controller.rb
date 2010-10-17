class Official::SeriesController < Official::OfficialController
  before_filter :assign_series, :check_series_rights, :except => :change_series

  def edit
  end

  def update
    if @series.update_attributes(params[:series])
      flash[:notice] = 'Sarjan asetukset päivitetty'
      redirect_to edit_official_series_path(@series)
    else
      render :edit
    end
  end

  def generate_numbers
    if @series.generate_numbers
      redirect_to edit_official_series_path(@series)
    else
      render :edit
    end
  end

  def generate_times
    if @series.generate_start_times
      redirect_to edit_official_series_path(@series)
    else
      render :edit
    end
  end

  def change_series
    redirect_to edit_official_series_path(params[:series_id])
  end

  private
  def assign_series
    @series = Series.find(params[:id])
  end

  def check_series_rights
    check_race(@series.race)
  end
end
