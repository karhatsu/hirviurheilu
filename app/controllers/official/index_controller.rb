class Official::IndexController < Official::OfficialController
  before_action :set_variant

  def show
    if current_user.admin?
      @races = Race.order('start_date DESC')
      @cups = Cup.all
    else
      @races = current_user.races
      @cups = current_user.cups
    end
  end
end
