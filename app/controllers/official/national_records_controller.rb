class Official::NationalRecordsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def index
  end
end
