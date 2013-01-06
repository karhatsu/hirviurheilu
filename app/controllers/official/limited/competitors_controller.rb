# encoding: UTF-8
class Official::Limited::CompetitorsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race_without_full_rights,
    :assign_race_right, :assign_current_competitors
  
  def index
    @is_limited_official = true
    @competitor = @race.series.first.competitors.build unless @race.series.empty?
  end
  
  def create
    assign_series(params[:competitor][:series_id])
    @competitor = @series.competitors.build(params[:competitor])
    @competitor.club = @race_right.club if @race_right.club
    if @competitor.save
      flash[:success] = 'Kilpailija lisätty'
      redirect_to official_limited_race_competitors_path(@race)
    else
      render :index
    end
  end
  
  private
  def assign_race_right
    @race_right = current_user.race_rights.where(:race_id => @race.id).first
  end
  
  def assign_current_competitors
    if @race_right.club
      @competitors = @race.competitors.where(:club_id => @race_right.club.id)
    else
      @competitors = @race.competitors
    end
  end
end