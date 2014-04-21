class ResultRotationsController < ApplicationController
  before_action :assign_race_by_race_id, :set_races

  def show
    @rotation = cookies[result_rotation_cookie_name]
  end
  
  def create
    cookies[result_rotation_cookie_name] = 3
    cookies[result_rotation_scroll_cookie_name] = true if params[:auto_scroll]
    cookies[result_rotation_tc_cookie_name] = true if params[:team_competitions]
    redirect_to race_result_rotation_path(@race)
  end
  
  def destroy
    cookies.delete result_rotation_cookie_name
    cookies.delete result_rotation_scroll_cookie_name
    cookies.delete result_rotation_tc_cookie_name
    redirect_to race_result_rotation_path(@race)
  end
end
