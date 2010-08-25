class Official::CompetitorsController < Official::OfficialController
  before_filter :check_competitor_rights
  before_filter :handle_time_parameters, :only => :update

  def index
    @series = Series.find(params[:series_id])
  end

  def new
    @series = Series.find(params[:series_id])
    @competitor = @series.competitors.build
    @competitor.number = @series.next_number
  end

  def create
    @series = Series.find(params[:series_id])
    @competitor = @series.competitors.build(params[:competitor])
    if @competitor.save
      if params[:create_another]
        flash[:notice] = "Kilpailija lisätty"
        redirect_to new_official_series_competitor_path(@series)
      else
        redirect_to official_series_competitors_path(@series)
      end
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

  def generate_times
    @series = Series.find(params[:series_id])
    if @series.generate_start_times
      redirect_to official_series_competitors_path(@series)
    else
      render :index
    end
  end

  private
  def check_competitor_rights
    series = Series.find(params[:series_id])
    check_race(series.race)
  end

  def handle_time_parameters
    handle_time_parameter "start_time"
    handle_time_parameter "arrival_time"
  end

  # f.time_text_field creates hidden date fields and visible text fields.
  # When time is entered the first time, the params sent contain an empty date
  # and non-empty time. This throws an error in assigning multiparameter values.
  # For that reason we must define also date parameters before assigning form
  # parameters to the company object.
  # When the time fields are cleared, we must do the opposite: we must reset
  # the date fields since otherwise the time after update would be 0:00:00.
  def handle_time_parameter(time_name)
    if time_cleared?(params[:competitor], time_name)
      reset_date_parameters(params[:competitor], time_name)
    else
      set_default_date_parameters(params[:competitor], time_name)
    end
  end

  def time_cleared?(competitor_params, time_name)
    competitor_params["#{time_name}(4i)"] == '' and
      competitor_params["#{time_name}(5i)"] == '' and
      competitor_params["#{time_name}(6i)"] == ''
  end

  def reset_date_parameters(competitor_params, time_name)
    competitor_params["#{time_name}(1i)"] = ""
    competitor_params["#{time_name}(2i)"] = ""
    competitor_params["#{time_name}(3i)"] = ""
  end

  def set_default_date_parameters(competitor_params, time_name)
    competitor_params["#{time_name}(1i)"] = "2000"
    competitor_params["#{time_name}(2i)"] = "1"
    competitor_params["#{time_name}(3i)"] = "1"
  end

end
