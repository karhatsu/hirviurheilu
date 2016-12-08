class Official::Limited::CompetitorsController < Official::Limited::LimitedOfficialController
  include CompetitorsHelper

  before_action :assign_race_by_race_id, :check_assigned_race_without_full_rights,
    :assign_race_right, :assign_current_competitors, :set_limited_official, :set_limited_official_add_competitor
  before_action :assign_competitor, :only => [:edit, :update, :destroy]
  
  def index
    redirect_to new_official_limited_race_competitor_path(@race)
  end

  def new
    return if @race.series.empty?
    series = @race.series.where(:id => params[:series_id]).first if params[:series_id]
    series = @race.series.first unless series
    @competitor = series.competitors.build
    @competitor.age_group_id = params[:age_group_id]
  end
  
  def create
    @competitor = @race.competitors.build(competitor_params)
    club_ok = true
    if @race_right.new_clubs?
      club_ok = handle_club(@competitor)
    else
      @competitor.club = @race_right.club if @race_right.club
    end
    if club_ok && @competitor.save
      flash[:success] = 'Kilpailija lisätty'
      redirect_to new_official_limited_race_competitor_path(@race, :series_id => @competitor.series_id,
        :age_group_id => @competitor.age_group_id)
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @competitor.update(competitor_params)
      flash[:success] = 'Kilpailija päivitetty'
      redirect_to new_official_limited_race_competitor_path(@race)
    else
      render :edit
    end
  end
  
  def destroy
    @competitor.destroy
    flash[:success] = 'Kilpailija poistettu'
    redirect_to new_official_limited_race_competitor_path(@race)
  end
  
  private
  def set_limited_official_add_competitor
    @limited_add_competitor = true
  end

  def assign_current_competitors
    if @race_right.club
      @competitors = @race.competitors.where(:club_id => @race_right.club.id)
    else
      @competitors = @race.competitors
    end
  end
  
  def assign_competitor
    conditions = { :id => params[:id] }
    conditions[:club_id] = @race_right.club.id if @race_right.club
    @competitor = @race.competitors.where(conditions).first
  end

  def competitor_params
    params.require(:competitor).permit(:series_id, :age_group_id, :first_name, :last_name, :club_id, :team_name)
  end
end