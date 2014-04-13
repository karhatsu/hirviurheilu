class Official::CompetitorsController < Official::OfficialController
  before_filter :assign_series_by_series_id, :check_assigned_series, :except => :create
  before_filter :assign_race_by_race_id, :check_assigned_race, :only => :create
  before_filter :assign_competitor_by_id, only: [ :edit, :update, :destroy ]
  before_filter :check_offline_limit, :only => [:new, :create]
  before_filter :handle_start_time, :only => :create
  before_filter :clear_empty_shots, :only => :update
  before_filter :set_competitors

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
  end

  # official/races/:race_id/competitors (not series)
  def create
    assign_series(params[:competitor][:series_id])
    @competitor = @series.competitors.build(add_competitor_params)
    club_ok = handle_club(@competitor)
    start_list_page = params[:start_list]
    if club_ok and @competitor.save
      start_list_condition = "series.has_start_list = #{DatabaseHelper.true_value}"
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
  end

  def update
    club_ok = handle_club(@competitor)
    change_series_id_to_series(params) # counter cache hack
    if club_ok and handle_time_parameters and @competitor.update(update_competitor_params)
      js_template = params[:start_list] ? 'official/start_lists/update_success' :
        'official/competitors/update_success'
      respond_to do |format|
        format.html do
          if params[:next]
            redirect_to edit_official_series_competitor_path(@competitor.series,
              @competitor.next_competitor)
          elsif params[:previous]
            redirect_to edit_official_series_competitor_path(@competitor.series,
              @competitor.previous_competitor)
          else
            redirect_to official_series_competitors_path(@competitor.series)
          end
        end
        format.js { render js_template, :layout => false }
      end
    else
      respond_to do |format|
        format.html { render :edit }
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
  def check_offline_limit
    return if online?
    return if ActivationKey.activated?
    if Competitor.free_offline_competitors_left <= 0
      respond_to do |format|
        format.html { render :offline_limit }
        format.js { render :offline_limit }
      end
    end
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
  
  def change_series_id_to_series(params)
    return unless params[:competitor].has_key?(:series_id)
    series = Series.find(params[:competitor][:series_id])
    params[:competitor][:series] = series
    params[:competitor].delete :series_id
  end

  def handle_club(competitor)
    competitor.club_id = params[:club_id] if params[:club_id] and params[:club_id].to_i != 0
    if competitor.club_id.nil? and !params[:club_name].blank?
      new_name = params[:club_name]
      existing_club = competitor.series.race.clubs.find_by_name(new_name)
      if existing_club
        competitor.club = existing_club
      else
        competitor.club = Club.create!(:race => competitor.series.race, :name => new_name)
      end
    end
    # Cucumber hack
    if Rails.env.test?
      if competitor.club.nil? and competitor.club_id.nil? and params[:club]
        competitor.club_id = params[:club]
      end
    end
    unless competitor.club_id
      # have to do this here instead of the competitor model since cannot have
      # the presence validation for club due to the nested forms usage
      competitor.errors.add :club, :empty
      return false
    end
    true
  end
  
  def clear_empty_shots
    shots_params = params[:competitor]["shots_attributes"]
    return unless shots_params
    10.times do |i|
      shot_param = shots_params["new_#{i}_shots"]
      shots_params.delete("new_#{i}_shots") if shot_param and shot_param["value"].blank?
    end
  end

  def set_competitors
    @is_competitors = true
  end

  def add_competitor_params
    params.require(:competitor).permit(:series_id, :age_group_id, :club_id, :first_name, :last_name, :unofficial,
      :team_name, :number, :start_time)
  end

  def update_competitor_params
    shots_attrs = [:id, :value]
    10.times { |i| shots_attrs << { "new_#{i}_shots" => :value } }
    params.require(:competitor).permit(:series_id, :age_group_id, :club_id, :first_name, :last_name, :unofficial,
      :team_name, :number, :start_time, :arrival_time, :shots_total_input, :estimate1, :estimate2, :estimate3,
      :estimate4, :no_result_reason, old_values: [:estimate1, :estimate2, :estimate3, :estimate4],
      shots_attributes: shots_attrs)
  end
end
