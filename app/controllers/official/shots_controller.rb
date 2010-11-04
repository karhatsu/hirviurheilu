class Official::ShotsController < Official::OfficialController
  before_filter :check_race_rights, :set_shots

  def index
    @series = Series.find(params[:series_id])
  end

  private
  def check_race_rights
    check_race(Series.find(params[:series_id]).race)
  end

  def set_shots
    @is_shots = true
  end
end
