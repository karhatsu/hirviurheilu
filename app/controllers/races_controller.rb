class RacesController < ApplicationController
  before_filter :set_races
  before_filter :assign_race_by_id, :only => :show

  def index
    @races = Race.order('start_date DESC')
  end

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
