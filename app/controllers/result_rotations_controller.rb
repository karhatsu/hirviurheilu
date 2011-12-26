class ResultRotationsController < ApplicationController
  before_filter :assign_race_by_race_id, :set_races

  def show
    @rotation = cookies[result_rotation_cookie_name]
  end
  
  def create
    cookies[result_rotation_cookie_name] = 3
    redirect_to race_result_rotation_path(@race)
  end
  
  def destroy
    cookies.delete result_rotation_cookie_name
    redirect_to race_result_rotation_path(@race)
  end
end
