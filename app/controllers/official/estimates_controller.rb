class Official::EstimatesController < Official::OfficialController
  before_filter :check_race_rights, :set_estimates

  def index
    @series = Series.find(params[:series_id])
  end

  private
  def check_race_rights
    check_race(Series.find(params[:series_id]).race)
  end

  def set_estimates
    @is_estimates = true
  end
end
