class Official::FinalRoundBatchResultsController < Official::BatchResultsController
  def create
    batch = @race.final_round_batches.where(number: params[:number]).first
    process_batch batch
  end
end
