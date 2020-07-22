class Official::NordicRaceShotsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def trap
    @sub_sport = :trap
    @is_trap = true
    render :index
  end

  def shotgun
    @sub_sport = :shotgun
    @is_shotgun = true
    render :index
  end

  def rifle_moving
    @sub_sport = :rifle_moving
    @is_rifle_moving = true
    render :index
  end

  def rifle_standing
    @sub_sport = :rifle_standing
    @is_rifle_standing = true
    render :index
  end
end
