class Official::Limited::CompetitorsController < Official::Limited::LimitedOfficialController
  include CompetitorsHelper

  before_action :assign_race_by_race_id, :check_assigned_race_without_full_rights, :assign_race_right
  before_action :assign_competitor, only: [:update, :destroy]

  def index
    respond_to do |format|
      format.html { redirect_to new_official_limited_race_competitor_path(@race) }
      format.json { assign_current_competitors }
    end
  end

  def show
    respond_to do |format|
      format.json do
        assign_competitor
        return render status: 404, json: { errors: ['Kilpailijaa ei löytynyt'] } unless @competitor
      end
    end
  end

  def new
    use_react true
    render layout: true, html: ''
  end

  def create
    @competitor = @race.competitors.build(competitor_params)
    @competitor.number = @race.next_start_number if @race.sport.heat_list?
    club_ok = true
    if @race_right.new_clubs?
      club_ok = handle_club(@competitor)
    else
      @competitor.club = @race_right.club if @race_right.club
    end
    if club_ok && @competitor.save
      respond_to do |format|
        format.json
      end
    else
      render status: 400, json: { errors: @competitor.errors.full_messages }
    end
  end

  def edit
    use_react true
    render layout: true, html: ''
  end

  def update
    if @competitor.update(competitor_params)
      respond_to do |format|
        format.json
      end
    else
      render status: 400, json: { errors: @competitor.errors.full_messages }
    end
  end

  def destroy
    @competitor.destroy
    flash[:success] = 'Kilpailija poistettu'
    respond_to do |format|
      format.html { redirect_to new_official_limited_race_competitor_path(@race) }
      format.json { render status: 201, body: nil }
    end
  end

  private
  def assign_current_competitors
    @competitors = @race.competitors.includes(:series, :age_group)
    if @race_right.club
      @competitors = @competitors.where(club_id: @race_right.club.id)
    end
  end

  def assign_competitor
    conditions = { :id => params[:id] }
    conditions[:club_id] = @race_right.club.id if @race_right.club
    @competitor = @race.competitors.where(conditions).first
  end

  def competitor_params
    params.require(:competitor).permit(
      :age_group_id,
      :caliber,
      :club_id,
      :first_name,
      :last_name,
      :series_id,
      :team_name
    )
  end
end
