class Official::IndexController < Official::OfficialController
  before_action :set_variant

  def show
    if current_user.admin?
      @today = Race.today.order('start_date ASC')
      @future = Race.future
      @past = Race.past.order('start_date DESC')
      @cups = Cup.all
    else
      @today = current_user.races.today
      @future = current_user.races.future
      @past = current_user.races.past
      @cups = current_user.cups
    end
  end
end
