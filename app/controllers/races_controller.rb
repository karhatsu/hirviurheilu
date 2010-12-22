class RacesController < ApplicationController

  def show
    @race = Race.find(params[:id])
    @is_race = true
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@race.name} - tulokset", :layout => true
      end
    end
  end

end
