class Official::IndexController < Official::OfficialController
  def show
    if current_user.admin?
      @today = Race.today.order('start_date ASC')
      @yesterday = Race.yesterday
      @future = Race.future
      @past = Race.past.order('start_date DESC')
      @cups = Cup.all.order('created_at DESC')
    else
      @today = current_user.races.today
      @yesterday = current_user.races.yesterday
      @future = current_user.races.future
      @past = current_user.races.past
      @cups = current_user.cups.order('created_at DESC')
    end
  end
end
