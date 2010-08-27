class Official::IndexController < Official::OfficialController
  def show
    if current_user.admin?
      @races = Race.find(:all, :order => 'start_date DESC')
    else
      @races = current_user.races.find(:all, :order => 'start_date DESC')
    end
  end
end
