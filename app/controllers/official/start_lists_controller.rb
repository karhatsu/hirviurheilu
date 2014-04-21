# encoding: UTF-8
require 'database_helper.rb'

class Official::StartListsController < Official::OfficialController
  include DatabaseHelper
  before_action :assign_race_by_race_id, :check_assigned_race, :only => :show
  before_action :assign_series_by_series_id, :check_assigned_series, :only => :update
  before_action :handle_time_parameters, :only => :update
  
  def show
    @is_start_list = true
    start_list_condition = "series.has_start_list = #{DatabaseHelper.true_value}"
    @competitors = @race.competitors.where(start_list_condition).includes(:club, :age_group, :series).except(:order).order(:number)
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
      flash[:success] = t('official.start_lists.update.start_list_create_for_series') + " #{@series.name}"
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

  def series_params
    params.require(:series).permit(:start_time, :first_number, :start_day)
  end
end
