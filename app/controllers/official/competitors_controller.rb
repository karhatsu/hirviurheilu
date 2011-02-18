class Official::CompetitorsController < Official::OfficialController
  before_filter :assign_series_by_series_id, :check_assigned_series, :except => :create
  before_filter :assign_race_by_race_id, :check_assigned_race, :only => :create
  before_filter :check_offline_limit, :only => [:new, :create]
  before_filter :handle_start_time, :only => :create
  before_filter :handle_time_parameters, :only => :update
  before_filter :set_competitors

  def index
    # for start list generation:
    @order_method = params[:order_method] ? params[:order_method].to_i :
      Series::START_LIST_RANDOM
  end

  def new
    next_number = @series.next_number
    next_start_time = @series.next_start_time
    @competitor = @series.competitors.build # cannot call next-methods after this
    if @series.has_start_list
      @competitor.number = next_number
      @competitor.start_time = next_start_time
    end
  end

  # official/races/:race_id/competitors (not series)
  def create
    assign_series(params[:competitor][:series_id])
    @competitor = @series.competitors.build(params[:competitor])
    handle_club(@competitor)
    if @competitor.save
      respond_to do |format|
        format.js { render :create_success }
      end
    else
      respond_to do |format|
        format.js { render :create_error }
      end
    end
  end

  def edit
    @competitor = Competitor.find(params[:id])
  end

  def update
    @competitor = Competitor.find(params[:id])
    handle_club(@competitor)
    if @competitor.update_attributes(params[:competitor])
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
        format.js { render 'official/competitors/update_success', :layout => false }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js { render 'official/competitors/update_error', :layout => false }
      end
    end
  end

  def destroy
    @competitor = Competitor.find(params[:id])
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
    render :offline_limit if Competitor.free_offline_competitors_left <= 0
  end

  def handle_start_time
    return if params[:no_times]
    handle_time_parameter params[:competitor], "start_time"
  end

  def handle_time_parameters
    return if params[:no_times]
    handle_time_parameter params[:competitor], "start_time"
    handle_time_parameter params[:competitor], "arrival_time"
  end

  def handle_club(competitor)
    if params[:club_id]
      competitor.club_id = params[:club_id]
    end
    unless competitor.club_id or params[:club_name].blank?
      existing_club = competitor.series.race.clubs.find_by_name(params[:club_name])
      if existing_club
        competitor.club = existing_club
      else
        competitor.club = Club.create!(:race => competitor.series.race,
          :name => params[:club_name])
      end
    end
    # Cucumber hack
    if Rails.env == 'test'
      if competitor.club.nil? and competitor.club_id.nil? and params[:club]
        competitor.club_id = params[:club]
      end
    end
  end

  def set_competitors
    @is_competitors = true
  end

end
