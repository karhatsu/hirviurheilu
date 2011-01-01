class Official::StartListsController < Official::OfficialController
  before_filter :assign_series_by_series_id, :check_assigned_series, :set_start_list
  before_filter :handle_time_parameters, :only => :update

  def show
    @order_method = params[:order_method] ? params[:order_method].to_i :
      Series::START_LIST_RANDOM
  end

  def update
    @order_method = params[:order_method].to_i
    if @series.update_attributes(params[:series]) and
        @series.generate_start_list(@order_method)
      redirect_to official_series_start_list_path(@series,
        :order_method => params[:order_method])
    else
      render :show
    end
  end

  private
  def set_start_list
    @is_start_list = true
  end

  def handle_time_parameters
    handle_time_parameter params[:series], "start_time"
  end
end
