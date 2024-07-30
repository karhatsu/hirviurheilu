class Official::QualificationRoundHeatResultsController < Official::HeatResultsController
  def create
    heat = @race.qualification_round_heats.where(number: params[:number]).first
    process_heat heat
  end
end
