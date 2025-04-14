class Official::TimesController < Official::OfficialController
  before_action :assign_series_by_series_id, :check_assigned_series, :require_three_sports_race, :set_times

  def index
    use_react true
    render layout: true, html: ''
  end

  private
  def set_times
    @is_times = true
  end
end
