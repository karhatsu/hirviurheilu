class Official::UploadsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race, :check_offline

  def new
  end

  private
  def check_offline
    redirect_to official_race_path(@race) if online?
  end
end
