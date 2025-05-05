class Official::ShotsController < Official::OfficialController
  before_action :assign_series_by_series_id, :check_assigned_series, :set_shots

  def index
    use_react true
    render layout: true, html: ''
  end

  private
  def set_shots
    @is_shots = true
  end
end
