class Official::ShootingByBatchesController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_menu

  def index
    @batch_options = @race.batches.sort { |a, b| [b.type, a.number] <=> [a.type, b.number] }.map {|b| [batch_name(b), b.id]}
    @batch = @race.batches.find(params[:batch_id]) unless params[:batch_id].blank?
  end

  private

  def set_menu
    @is_shots_by_batches = true
  end

  def batch_name(batch)
    "#{batch.is_a?(FinalRoundBatch) ? t('attributes.final_round_batch_id') : t('attributes.qualification_round_batch_id')} #{batch.number}"
  end
end
