class Official::StartListsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :only => :show
  before_action :assign_series_by_series_id, :check_assigned_series, :only => :update
  before_action :handle_time_parameters, :only => :update
  before_action :require_three_sports_race

  def show
    use_react true
    render layout: true, html: ''
  end

  def update
    @order_method = params[:order_method].to_i
    if @series.update(series_params) && @series.generate_start_list(@order_method)
      @series.touch
      flash[:success] = t('official.start_lists.update.start_list_create_for_series') + " #{@series.name}"
      redirect_to official_race_series_competitors_path(@series.race_id, @series, order_method: params[:order_method])
    else
      render 'official/competitors/index'
    end
  end

  private

  def handle_time_parameters
    handle_time_parameter params[:series], "start_time"
  end

  def series_params
    params.require(:series).permit(:start_time, :first_number, :start_day)
  end
end
