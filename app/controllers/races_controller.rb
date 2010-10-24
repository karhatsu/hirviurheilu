class RacesController < ApplicationController

  def show
    @race = Race.find(params[:id])
    @is_race = true
  end

end
