class Official::NordicRaceShotsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def trap
    @sub_sport = :trap
    @is_trap = true
    use_react true
    render layout: true, html: ''
  end

  def shotgun
    @sub_sport = :shotgun
    @is_shotgun = true
    use_react true
    render layout: true, html: ''
  end

  def rifle_moving
    @sub_sport = :rifle_moving
    @is_rifle_moving = true
    use_react true
    render layout: true, html: ''
  end

  def rifle_standing
    @sub_sport = :rifle_standing
    @is_rifle_standing = true
    use_react true
    render layout: true, html: ''
  end
end
