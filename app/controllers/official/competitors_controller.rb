class Official::CompetitorsController < Official::OfficialController
  include CompetitorsHelper

  before_action :assign_series_by_series_id, :check_assigned_series, except: [:show_by_number, :create]
  before_action :assign_race_by_race_id, :check_assigned_race, only: [:show_by_number, :create]
  before_action :assign_competitor_by_id, only: [ :edit, :update, :destroy ]
  before_action :handle_start_time, :only => :create
  before_action :set_competitors

  def index
    if @series.race.sport.three_sports?
      # for start list generation:
      @order_method = params[:order_method] ? params[:order_method].to_i :
        Series::START_LIST_RANDOM
      @series.first_number = @series.race.next_start_number unless @series.first_number
      @series.start_time = @series.race.next_start_time unless @series.start_time
    end
  end

  def show_by_number
    competitor = @race.competitors.where(number: params[:number]).first
    if competitor
      render json: competitor, only: [:id, :first_name, :last_name], methods: [:series_name]
    else
      render status: 404, json: nil
    end
  end

  def new
    next_number = @series.race.next_start_number
    next_start_time = @series.race.next_start_time
    @competitor = @series.competitors.build # cannot call next-methods after this
    if @series.has_start_list
      @competitor.number = next_number
      @competitor.start_time = next_start_time
    elsif @series.sport.heat_list?
      @competitor.number = next_number
    end
    @series_menu_options = @series.race.series
  end

  # official/races/:race_id/competitors (not series)
  def create
    assign_series(params[:competitor][:series_id])
    @competitor = @series.competitors.build(add_competitor_params)
    @competitor.number = @series.race.next_start_number if @series.sport.heat_list? && @competitor.number.blank?
    club_ok = handle_club(@competitor)
    start_list_page = params[:start_list]
    if club_ok && @competitor.save
      start_list_condition = 'series.has_start_list = true'
      @all_series = @race.series.where(start_list_condition)
      collect_age_groups(@all_series)
      template = start_list_page ? 'official/start_lists/create_success' :
        'official/competitors/create_success'
      respond_to { |format| format.js { render template } }
    else
      template = start_list_page ? 'official/start_lists/create_error' :
        'official/competitors/create_error'
      respond_to { |format| format.js { render template } }
    end
  end

  def edit
    set_series_list_options_in_edit
  end

  def update
    club_ok = handle_club(@competitor)
    @competitor.old_values = params[:old_values]
    update_params = update_competitor_params
    shots_ok = Competitor::ALL_SHOTS_FIELDS.map { |shots_name| set_shots @competitor, shots_name, params[shots_name] }.all?
    @sub_sport = params[:sub_sport]
    if club_ok && shots_ok && handle_time_parameters && @competitor.update(update_params)
      js_template = params[:start_list] ? 'official/start_lists/update_success' :
        'official/competitors/update_success'
      respond_to do |format|
        format.html do
          redirect_to official_series_competitors_path(@competitor.series)
        end
        format.js { render js_template, :layout => false }
        format.json
      end
    else
      respond_to do |format|
        format.html do
          set_series_list_options_in_edit
          render :edit
        end
        format.js { render 'official/competitors/update_error', :layout => false }
        format.json { render status: 400, json: { errors: @competitor.errors.full_messages } }
      end
    end
  end

  def destroy
    if @competitor.series_id == params[:series_id].to_i
      @competitor.destroy
      redirect_to official_series_competitors_path(@competitor.series_id)
    else
      raise "Competitor does not belong to given series!"
    end
  end

  private

  def set_series_list_options_in_edit
    start_list_condition = "series.has_start_list = #{@series.has_start_list?}"
    @series_menu_options = @series.race.series.where(start_list_condition)
  end

  def handle_start_time
    handle_time_parameter params[:competitor], "start_time"
  end

  def handle_time_parameters
    start_ok = handle_time_parameter params[:competitor], "start_time"
    @competitor.errors.add(:start_time, 'virheellinen') unless start_ok
    arrival_ok = handle_time_parameter params[:competitor], "arrival_time"
    @competitor.errors.add(:arrival_time, 'virheellinen') unless arrival_ok
    start_ok and arrival_ok
  end

  def set_competitors
    @is_competitors = true
  end

  def add_competitor_params
    params.require(:competitor).permit(:series_id, :age_group_id, :club_id, :first_name, :last_name, :unofficial,
      :team_name, :number, :start_time, :only_rifle, :qualification_round_heat_id, :qualification_round_track_place,
      :final_round_heat_id, :final_round_track_place)
  end

  def update_competitor_params
    params.require(:competitor).permit(
      :age_group_id,
      :arrival_time,
      :club_id,
      :estimate1,
      :estimate2,
      :estimate3,
      :estimate4,
      :european_compak_score_input,
      :european_compak_score_input2,
      :european_extra_score,
      :european_rifle1_score_input,
      :european_rifle1_score_input2,
      :european_rifle2_score_input,
      :european_rifle2_score_input2,
      :european_rifle3_score_input,
      :european_rifle3_score_input2,
      :european_rifle4_score_input,
      :european_rifle4_score_input2,
      :european_shotgun_extra_score,
      :european_trap_score_input,
      :european_trap_score_input2,
      :final_round_heat_id,
      :final_round_shooting_score_input,
      :final_round_track_place,
      :first_name,
      :last_name,
      :no_result_reason,
      :nordic_extra_score,
      :nordic_rifle_moving_score_input,
      :nordic_rifle_standing_score_input,
      :nordic_shotgun_score_input,
      :nordic_trap_score_input,
      :number,
      :only_rifle,
      :qualification_round_heat_id,
      :qualification_round_shooting_score_input,
      :qualification_round_track_place,
      :series_id,
      :shooting_overtime_min,
      :shooting_rules_penalty,
      :shooting_rules_penalty_qr,
      :shooting_score_input,
      :start_time,
      :team_name,
      :unofficial
    )
  end
end
