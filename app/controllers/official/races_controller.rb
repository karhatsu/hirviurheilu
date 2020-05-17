class Official::RacesController < Official::OfficialController
  before_action :assign_race_by_id, except: [:new, :create, :competitors]
  before_action :assign_race_by_race_id, only: :competitors
  before_action :check_assigned_race, except: [:new, :create]
  before_action :create_points_method_options
  before_action :set_sports

  def show
    @is_race = true
  end

  def new
    @race = Race.new
    @race.start_time = '00:00'
    @race.start_interval_seconds = Race::DEFAULT_START_INTERVAL
    @race.batch_size = 0
    @race.batch_interval_seconds = Race::DEFAULT_BATCH_INTERVAL
    @race.sport_key = params[:sport_key]
    @race.start_order = Race::START_ORDER_NOT_SELECTED
  end

  def create
    @race = Race.new(create_race_params)
    if @race.save
      current_user.race_rights.create!(race: @race, primary: true)
      flash[:success] = t('official.races.create.race_added') + ". "
      if params[:add_default_series]
        @race.add_default_series
        flash[:success] << t('official.races.create.add_competitors_info')
        redirect_to official_race_path(@race)
      elsif !params[:copy_series].blank?
        @race.copy_series_from Race.find(params[:copy_series])
        redirect_to official_race_path(@race)
      else
        flash[:success] << t('official.races.create.add_series_info')
        redirect_to edit_official_race_path(@race)
      end
    else
      render :new
    end
  end

  def edit
    @is_race_edit = true
  end

  def update
    if @race.update(update_race_params)
      flash[:success] = t '.updated'
      redirect_to official_race_path(@race)
    else
      render :edit
    end
  end

  def destroy
    if @race.destroy
      flash[:success] = t('official.races.destroy.race_removed')
    else
      flash[:error] = t('official.races.destroy.cannot_remove_race') + ": #{@race.errors[:base]}"
    end
    redirect_to official_root_path
  end

  def competitors
    respond_to do |format|
      format.pdf do
        @all_series = @race.series.includes(competitors: [:club])
        render pdf: "#{@race.name}-kilpailijat-sarjoittain", layout: true, margin: pdf_margin,
               header: pdf_header("#{@race.name} - Kilpailijat sarjoittain\n"), footer: pdf_footer,
               disable_smart_shrinking: true
      end
    end
  end

  private
  def create_points_method_options
    @points_method_options = [
        Series::POINTS_METHOD_TIME_2_ESTIMATES,
        Series::POINTS_METHOD_TIME_4_ESTIMATES,
        Series::POINTS_METHOD_300_TIME_2_ESTIMATES,
        Series::POINTS_METHOD_NO_TIME_2_ESTIMATES,
        Series::POINTS_METHOD_NO_TIME_4_ESTIMATES
    ].map { |points_method| [t("points_method_#{points_method}.both"), points_method] }
  end

  def set_sports
    sport_keys = [Sport::RUN, Sport::SKI, Sport::ILMAHIRVI, Sport::ILMALUODIKKO, Sport::METSASTYSHIRVI,
                  Sport::METSASTYSLUODIKKO, Sport::METSASTYSHAULIKKO, Sport::METSASTYSTRAP]
    if !ProductionEnvironment.production?
      sport_keys << Sport::NORDIC
    end
    @sports = sport_keys.map{|key| [t("sport_name.#{key}"), key]}
  end

  def create_race_params
    params.require(:race).permit(accepted_create_params)
  end

  def update_race_params
    accepted = accepted_create_params
    accepted << { series_attributes: [:id, :name, :national_record, :points_method, :shorter_trip, :_destroy,
                                      age_groups_attributes: [:id, :name, :min_competitors, :shorter_trip, :_destroy]] }
    params.require(:race).permit(accepted)
  end

  def accepted_create_params
    [ :sport_key, :name, :district_id, :location, 'start_date(1i)', 'start_date(2i)', 'start_date(3i)',
      'start_time(1i)', 'start_time(2i)', 'start_time(3i)', 'start_time(4i)', 'start_time(5i)',
      :days_count, :club_level, :organizer, :home_page, :organizer_phone, :address, :shooting_place_count, :track_count,
      :start_interval_seconds, :start_order, :batch_size, :batch_interval_seconds, :billing_info, :public_message ]
  end
end
