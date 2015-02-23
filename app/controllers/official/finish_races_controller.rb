class Official::FinishRacesController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def new
  end

  def create
    if @race.finish
      FinishRaceMailer.finish_race(@race).deliver_now
      flash[:success] = t('official.finish_races.create.race_finished', :race_name => @race.name)
      redirect_to official_race_path(@race)
    else
      render :new
    end
  end
end
