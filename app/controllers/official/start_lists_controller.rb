class Official::StartListsController < Official::OfficialController
  before_filter :assign_series, :check_race_rights, :set_start_list

  def show
  end

  def update
    @series.update_attributes(params[:series])
    @series.generate_start_list
    redirect_to official_series_start_list_path(@series)
  end

  private
  def assign_series
    @series = Series.find(params[:series_id])
  end

  def check_race_rights
    check_race(@series.race)
  end

  def set_start_list
    @is_start_list = true
  end
end
