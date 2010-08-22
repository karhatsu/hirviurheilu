class Official::IndexController < Official::OfficialController
  def show
    #TODO: only own races
    @races = Race.all
  end
end
