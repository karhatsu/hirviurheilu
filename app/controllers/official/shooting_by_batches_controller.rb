class Official::ShootingByBatchesController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_menu

  def index
    @batches = @race.batches
    @batch = @race.batches.find(params[:batch_id]) unless params[:batch_id].blank?
  end

  private

  def set_menu
    @is_shots_by_batches = true
  end
end
