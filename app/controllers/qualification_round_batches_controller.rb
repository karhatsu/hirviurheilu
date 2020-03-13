class QualificationRoundBatchesController < BatchesController
  before_action :set_menu, :assign_batches

  private

  def set_menu
    @is_races = true
    @is_qualification_round_batches = true
  end

  def assign_batches
    @batches = @race.qualification_round_batches.includes(competitors: [:club, :series])
  end
end
