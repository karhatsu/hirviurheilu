class Official::StartListsController < Official::OfficialController
  before_filter :assign_series_by_series_id, :check_assigned_series
  before_filter :handle_time_parameters, :only => :update

  def update
    @order_method = params[:order_method].to_i
    if @series.update_attributes(params[:series]) and
        @series.generate_start_list(@order_method)
      redirect_to official_series_competitors_path(@series,
        :order_method => params[:order_method])
    else
      render 'official/competitors/index'
    end
  end

  private
  def handle_time_parameters
    handle_time_parameter params[:series], "start_time"
  end
end
