class Official::CompetitorsController < Official::OfficialController
  include CompetitorsHelper

  before_action :assign_series_by_series_id, :check_assigned_series, :except => :create
  before_action :assign_race_by_race_id, :check_assigned_race, :only => :create
  before_action :assign_competitor_by_id, only: [ :edit, :update, :destroy ]
  before_action :handle_start_time, :only => :create
  before_action :set_competitors

  def index
    # for start list generation:
    @order_method = params[:order_method] ? params[:order_method].to_i :
      Series::START_LIST_RANDOM
    @series.first_number = @series.race.next_start_number unless @series.first_number
    @series.start_time = @series.race.next_start_time unless @series.start_time
  end

  def new
    next_number = @series.race.next_start_number
    next_start_time = @series.race.next_start_time
    @competitor = @series.competitors.build # cannot call next-methods after this
    if @series.has_start_list
      @competitor.number = next_number
      @competitor.start_time = next_start_time
    end
    @series_menu_options = @series.race.series
  end

  # official/races/:race_id/competitors (not series)
  def create
    assign_series(params[:competitor][:series_id])
    @competitor = @series.competitors.build(add_competitor_params)
    club_ok = handle_club(@competitor)
    start_list_page = params[:start_list]
    if club_ok and @competitor.save
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
    update_params = update_competitor_params
    set_shots unless params['shots'].blank?
    if club_ok && handle_time_parameters && @competitor.update(update_params)
      js_template = params[:start_list] ? 'official/start_lists/update_success' :
        'official/competitors/update_success'
      respond_to do |format|
        format.html do
          redirect_to official_series_competitors_path(@competitor.series)
        end
        format.js { render js_template, :layout => false }
      end
    else
      respond_to do |format|
        format.html do
          set_series_list_options_in_edit
          render :edit
        end
        format.js { render 'official/competitors/update_error', :layout => false }
      end
    end
  end

  def destroy
    if @competitor.series_id == params[:series_id].to_i
      @competitor.destroy
      respond_to do |format|
        format.js { render :destroyed }
      end
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
      :team_name, :number, :start_time)
  end

  def update_competitor_params
    params.require(:competitor).permit(:series_id, :age_group_id, :club_id, :first_name, :last_name, :unofficial,
      :team_name, :number, :start_time, :arrival_time, :shooting_score_input, :estimate1, :estimate2, :estimate3,
      :estimate4, :no_result_reason, :shooting_overtime_min, old_values: [:estimate1, :estimate2, :estimate3, :estimate4])
  end

  def set_shots
    shots = params['shots'].reject{|s| s.blank?}
    if shots.length > 0
      @competitor.shots = shots
    else
      @competitor.shots = nil
    end
  end
end
