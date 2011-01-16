class Official::FinishRacesController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race

  def new
  end

  def create
    if @race.finish
      flash[:success] = "Kilpailu #{@race.name} on merkitty päättyneeksi"
      redirect_to official_race_path(@race)
    else
      render :new
    end
  end
end
