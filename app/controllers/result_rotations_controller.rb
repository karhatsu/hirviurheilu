class ResultRotationsController < ApplicationController
  before_action :assign_race_by_race_id, :set_races

  def show
    @rotation = cookies[result_rotation_cookie_name]
  end
  
  def create
    cookies[result_rotation_cookie_name] = 3
    cookies[result_rotation_scroll_cookie_name] = true if params[:auto_scroll]
    cookies[result_rotation_tc_cookie_name] = true if params[:team_competitions]
    store_selected_competitions
    redirect_to race_result_rotation_path(@race)
  end
  
  def destroy
    cookies.delete result_rotation_cookie_name
    cookies.delete result_rotation_scroll_cookie_name
    cookies.delete result_rotation_tc_cookie_name
    cookies.delete result_rotation_selected_competitions_cookie_name
    redirect_to race_result_rotation_path(@race)
  end

  private

  def store_selected_competitions
    return unless params[:competition_paths]
    competition_paths = params[:competition_paths].join(',')
    cookies[result_rotation_selected_competitions_cookie_name] = competition_paths unless competition_paths.blank?
  end
end
