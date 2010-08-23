class Official::RacesController < Official::OfficialController
  before_filter :check_race_rights

  def edit
    @race = Race.find(params[:id])
  end

  def update
    @race = Race.find(params[:id])
    if @race.update_attributes(params[:race])
      redirect_to official_root_path
    else
      render :edit
    end
  end

  private
  def check_race_rights
    check_race(Race.find(params[:id]))
  end
end
