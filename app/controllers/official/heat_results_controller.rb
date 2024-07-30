class Official::HeatResultsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  private

  def process_heat(heat)
    return render status: 400, json: { errors: [t('official.heat_results.heat_not_found')] } unless heat
    errors = heat.save_results params[:results]
    return render status: 400, json: { errors: errors } unless errors.empty?
    render status: 201, body: nil
  end
end
