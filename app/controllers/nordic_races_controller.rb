class NordicRacesController < ApplicationController
  before_action :assign_race_by_race_id, :set_races

  def trap
    @sub_sport = :trap
    render :show
  end

  def shotgun
    @sub_sport = :shotgun
    render :show
  end

  def rifle_moving
    @sub_sport = :rifle_moving
    render :show
  end

  def rifle_standing
    @sub_sport = :rifle_standing
    render :show
  end
end
