class Official::Limited::LimitedOfficialController < Official::OfficialController
  private
  def set_limited_official
    @is_limited_official = true
  end

  def check_assigned_race_without_full_rights
    check_race(@race, false)
  end

  def assign_race_right
    @race_right = current_user.race_rights.where(:race_id => @race.id).first
  end
end