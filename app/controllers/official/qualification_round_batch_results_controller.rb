class Official::QualificationRoundBatchResultsController < Official::BatchResultsController
  def create
    batch = @race.qualification_round_batches.where(number: params[:number]).first
    process_batch batch
  end
end
