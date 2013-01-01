# encoding: UTF-8
class Official::Limited::CompetitorsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race_without_full_rights
  
  def index
    @is_limited_official = true
    @competitor = @race.series.first.competitors.build
  end
  
  def create
    assign_series(params[:competitor][:series_id])
    @competitor = @series.competitors.build(params[:competitor])
    if @competitor.save
      flash[:success] = 'Kilpailija lisätty'
      redirect_to official_limited_race_competitors_path(@race)
    else
      render :index
    end
  end
end