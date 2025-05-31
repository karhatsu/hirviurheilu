class Official::IndexController < Official::OfficialController
  def show
    if current_user.admin?
      @today = Race.today.except(:order).order('name')
      @yesterday = Race.yesterday.except(:order).order('name')
      @future = Race.future
      @before_yesterday = Race.before_yesterday.order('start_date DESC')
      @cups = Cup.all.order('created_at DESC')
    else
      @today = current_user.races.today.except(:order).order('name')
      @yesterday = current_user.races.yesterday.except(:order).order('name')
      @future = current_user.races.future.except(:order).order('start_date, name')
      @before_yesterday = current_user.races.before_yesterday
      @cups = current_user.cups.order('created_at DESC')
    end
    @events = current_user.events
  end
end
