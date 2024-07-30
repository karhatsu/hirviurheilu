class Official::FinalRoundHeatResultsController < Official::HeatResultsController
  def create
    heat = @race.final_round_heats.where(number: params[:number]).first
    process_heat heat
  end
end
