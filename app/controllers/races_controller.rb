class RacesController < ApplicationController

  def show
    @race = Race.find(params[:id])
  end

end
