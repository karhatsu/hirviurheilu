class Official::CompetitorsController < Official::OfficialController
  before_filter :assign_series_by_series_id, :check_assigned_series
  before_filter :handle_time_parameters, :only => :update
  before_filter :set_competitors

  def index
  end

  def new
    next_number = @series.next_number
    next_start_time = @series.next_start_time
    @competitor = @series.competitors.build # cannot call next-methods after this
    @competitor.number = next_number
    @competitor.start_time = next_start_time
  end

  def create
    @competitor = @series.competitors.build(params[:competitor])
    handle_club(@competitor)
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

  def set_competitors
    @is_competitors = true
  end

end
