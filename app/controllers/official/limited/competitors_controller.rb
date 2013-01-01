class Official::Limited::CompetitorsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race_without_full_rights
  
  def index
    @is_limited_official = true
  end
end