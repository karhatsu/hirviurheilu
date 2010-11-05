class Official::FinishRacesController < Official::OfficialController
  before_filter :check_race_rights

  def new
    @race = get_race
  end

  def create
    @race = get_race
    if @race.finish
      flash[:notice] = "Kilpailu #{@race.name} on merkitty päättyneeksi"
      redirect_to official_race_path(@race)
    else
      render :new
    end
  end

  private
  def get_race
    Race.find(params[:race_id])
  end

  def check_race_rights
    check_race(get_race)
  end
end
