class Official::CompetitorsController < Official::OfficialController
  def index
    @series = Series.find(params[:series_id])
  end

  def new
    @series = Series.find(params[:series_id])
    @competitor = @series.competitors.build
  end

  def create
    @series = Series.find(params[:series_id])
    @competitor = @series.competitors.build(params[:competitor])
    if @competitor.save
      redirect_to official_series_competitors_path(@competitor.series)
    else
      render :new
    end
  end

  def edit
    @competitor = Competitor.find(params[:id])
  end

  def update
    @competitor = Competitor.find(params[:id])
    if @competitor.update_attributes(params[:competitor])
      if params[:next]
        redirect_to edit_official_series_competitor_path(@competitor.series,
          @competitor.next_competitor)
      elsif params[:previous]
        redirect_to edit_official_series_competitor_path(@competitor.series,
          @competitor.previous_competitor)
      else
        redirect_to official_series_competitors_path(@competitor.series)
      end
    else
      render :edit
    end
  end
end
