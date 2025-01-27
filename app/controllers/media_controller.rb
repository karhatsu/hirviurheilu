class MediaController < ApplicationController
  def new
    redirect_to_press_path
  end

  def show
    redirect_to_press_path
  end

  private

  def redirect_to_press_path
    return redirect_to race_press_path(params[:race_id]), status: 301 if params[:race_id]
    return redirect_to cup_press_path(params[:cup_id]), status: 301 if params[:cup_id]
    redirect_to root_path
  end
end
