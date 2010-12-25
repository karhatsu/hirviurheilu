class Official::TimesController < Official::OfficialController
  before_filter :assign_series_by_series_id, :check_assigned_series, :set_times

  def index
  end

  private
  def set_times
    @is_times = true
  end
end
