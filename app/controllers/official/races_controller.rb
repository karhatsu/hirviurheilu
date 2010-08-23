class Official::RacesController < Official::OfficialController
  before_filter :check_race_rights

  private
  def check_race_rights
    check_race(Race.find(params[:id]))
  end
end
