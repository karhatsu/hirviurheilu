class Official::Limited::RacesController < Official::Limited::LimitedOfficialController
  before_action :assign_race_by_id, :check_assigned_race_without_full_rights, :assign_race_right

  def show
    respond_to do |format|
      format.json
    end
  end
end
