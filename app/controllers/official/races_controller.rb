# encoding: UTF-8
class Official::RacesController < Official::OfficialController
  before_filter :assign_race_by_id, :check_assigned_race, :except => [:new, :create]
  before_filter :create_time_points_type_options

  def show
    @is_race = true
  end

  def new
    @race = Race.new
    @race.start_interval_seconds = Race::DEFAULT_START_INTERVAL
    @race.batch_size = 0
    @race.batch_interval_seconds = Race::DEFAULT_BATCH_INTERVAL
    @race.sport = Sport.default_sport
    @race.start_order = Race::START_ORDER_NOT_SELECTED
  end

  def create
    @race = Race.new(params[:race])
    if @race.save
      current_user.race_rights.create!(:race => @race)
      NewCompetitionMailer.new_race(@race, current_user).deliver
      flash[:success] = t('official.races.create.race_added') + ". "
      if params[:add_default_series]
        @race.add_default_series
        flash[:success] << t('official.races.create.add_competitors_info')
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
    if @race.update_attributes(params[:race])
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

  private
  def create_time_points_type_options
    @time_points_type_options = [
      [t(:time_points_normal), Series::TIME_POINTS_TYPE_NORMAL],
      [t(:time_points_none), Series::TIME_POINTS_TYPE_NONE],
      [t(:time_points_300), Series::TIME_POINTS_TYPE_ALL_300]
    ]
  end
end
