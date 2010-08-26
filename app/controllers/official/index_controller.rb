class Official::IndexController < Official::OfficialController
  def show
    @races = current_user.races.find(:all, :order => 'start_date DESC')
  end
end
