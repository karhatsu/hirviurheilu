class Official::ShootingByHeatsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_menu

  def index
    @heat_options = @race.heats.sort { |a, b| [b.type, a.number] <=> [a.type, b.number] }.map {|b| [heat_name(b), b.id]}
    @heat = @race.heats.find(params[:heat_id]) unless params[:heat_id].blank?
  end

  private

  def set_menu
    @is_shooting_by_heats = true
  end

  def heat_name(heat)
    "#{heat.final_round? ? t('attributes.final_round_heat_id') : t('attributes.qualification_round_heat_id')} #{heat.number}"
  end
end
