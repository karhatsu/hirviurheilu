class Official::CorrectEstimatesController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race,
    :set_correct_estimates, :assign_competitors

  def index
  end

  def update
    if @race.update(params[:race])
      @race.set_correct_estimates_for_competitors
      redirect_to official_race_correct_estimates_path(@race)
    else
      render :index
    end
  end

  private
  def set_correct_estimates
    @is_correct_estimates = true
  end

  def assign_competitors
    @competitors = @race.competitors.includes(:series).except(:order).order('number, id')
  end
end
