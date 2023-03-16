class Official::QualificationRoundBatchResultsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def create
    batch = @race.qualification_round_batches.where(number: params[:number]).first
    return render status: 400, json: { errors: [t('.batch_not_found')] } unless batch
    errors = batch.save_results params[:results]
    return render status: 400, json: { errors: errors } unless errors.empty?
    render status: 201, body: nil
  end
end
