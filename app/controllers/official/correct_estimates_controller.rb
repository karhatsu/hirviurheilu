class Official::CorrectEstimatesController < Official::OfficialController
  before_filter :assign_race, :check_race_rights, :set_correct_estimates, :assign_competitors

  def index
  end

  def update
    if @race.update_attributes(params[:race])
      @race.set_correct_estimates_for_competitors
      redirect_to official_race_correct_estimates_path(@race)
    else
      render :index
    end
  end

  private
  def assign_race
    @race = Race.find(params[:race_id])
  end

  def check_race_rights
    check_race(@race)
  end

  def set_correct_estimates
    @is_correct_estimates = true
  end

  def assign_competitors
    @competitors = @race.competitors.order('number, id')
  end
end
