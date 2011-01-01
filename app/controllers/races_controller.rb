class RacesController < ApplicationController
  before_filter :assign_race_by_id

  def show
    @is_race = true
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@race.name} - tulokset", :layout => true
      end
    end
  end

end
