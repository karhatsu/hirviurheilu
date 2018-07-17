class Official::StartListsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :only => :show
  before_action :assign_series_by_series_id, :check_assigned_series, :only => :update
  before_action :handle_time_parameters, :only => :update

  def show
    @is_start_list = true
    start_list_condition = 'series.has_start_list = true'
    @competitors = @race.competitors.where(start_list_condition).includes(:club, :age_group, :series).except(:order).order(:number)
    @series_with_age_groups = find_series_with_age_groups
    @all_series = @race.series.where(start_list_condition)
    collect_age_groups(@all_series)
    unless @all_series.empty?
      @new_competitor = @all_series.first.competitors.build(:number => @race.next_start_number,
        :start_time => @race.next_start_time)
    end
  end

  def update
    @order_method = params[:order_method].to_i
    if @series.update(series_params) and
        @series.generate_start_list(@order_method)
      @series.touch
      flash[:success] = t('official.start_lists.update.start_list_create_for_series') + " #{@series.name}"
      redirect_to official_series_competitors_path(@series,
        :order_method => params[:order_method])
    else
      render 'official/competitors/index'
    end
  end

  private

  def find_series_with_age_groups
    series = @race.series.includes(:age_groups)
    series_with_age_groups = Hash.new
    series.each do |s|
      series_with_age_groups[s.id] = s.age_groups.map {|ag| [ag.id, ag.name]}
      series_with_age_groups[s.id].unshift([nil, s.name]) unless series_with_age_groups[s.id].empty?
    end
    series_with_age_groups
  end

  def handle_time_parameters
    handle_time_parameter params[:series], "start_time"
  end

  def series_params
    params.require(:series).permit(:start_time, :first_number, :start_day)
  end
end
