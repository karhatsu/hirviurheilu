class QualificationRoundHeatsController < HeatsController
  before_action :set_menu, :assign_heats

  private

  def set_menu
    @is_races = true
    @is_qualification_round_heats = true
  end

  def assign_heats
    @heats = @race.qualification_round_heats.includes(competitors: [:club, :series])
  end
end
