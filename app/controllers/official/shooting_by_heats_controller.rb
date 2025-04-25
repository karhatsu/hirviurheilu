class Official::ShootingByHeatsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_menu

  def index
    use_react true
    render layout: true, html: ''
  end

  private

  def set_menu
    @is_shooting_by_heats = true
  end
end
