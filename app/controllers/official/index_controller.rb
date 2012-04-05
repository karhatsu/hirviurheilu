class Official::IndexController < Official::OfficialController
  def show
    if current_user.admin?
      @races = Race.order('start_date DESC')
      @cups = Cup.all
    else
      @races = current_user.races.order('start_date DESC')
      @cups = current_user.cups
    end
  end
end
