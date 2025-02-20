class Official::IndexController < Official::OfficialController
  def show
    if current_user.admin?
      @today = Race.today.except(:order).order('name')
      @yesterday = Race.yesterday.except(:order).order('name')
      @future = Race.future
      @past = Race.past.order('start_date DESC')
      @cups = Cup.all.order('created_at DESC')
    else
      @today = current_user.races.today.except(:order).order('name')
      @yesterday = current_user.races.yesterday.except(:order).order('name')
      @future = current_user.races.future.except(:order).order('start_date, name')
      @past = current_user.races.past
      @cups = current_user.cups.order('created_at DESC')
    end
    @events = current_user.events
  end
end
