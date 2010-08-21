class Official::CompetitorsController < Official::OfficialController
  def index
    @series = Series.find(params[:series_id])
  end
end
