class Official::CompetitorsController < Official::OfficialController
  before_filter :check_competitor_rights
  before_filter :handle_time_parameters, :only => :update

  def new
    @series = Series.find(params[:series_id])
    @competitor = @series.competitors.build
    @competitor.number = @series.next_number
  end

  def create
    @series = Series.find(params[:series_id])
    @competitor = @series.competitors.build(params[:competitor])
    handle_club(@competitor)
    if @competitor.save
      if params[:create_another]
        flash[:notice] = "Kilpailija lisätty"
        redirect_to new_official_series_competitor_path(@series)
      else
        redirect_to edit_official_series_path(@series)
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
            redirect_to edit_official_series_path(@competitor.series)
          end
        end
        format.js { render 'official/competitors/updated', :layout => false }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js { render 'official/competitors/updated', :layout => false }
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
  def check_competitor_rights
    series = Series.find(params[:series_id])
    check_race(series.race)
  end

  def handle_time_parameters
    return if params[:no_times]
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

  def handle_club(competitor)
    if params[:club_id]
      competitor.club_id = params[:club_id]
    end
    unless competitor.club_id or params[:club_name].blank?
      competitor.club = Club.create!(:race => competitor.series.race,
        :name => params[:club_name])
    end
    # Cucumber hack
    if Rails.env == 'test'
      if competitor.club.nil? and competitor.club_id.nil? and params[:club]
        competitor.club_id = params[:club]
      end
    end
  end

end
