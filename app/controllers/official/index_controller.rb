class Official::IndexController < Official::OfficialController
  def show
    @races = current_user.races
  end
end
