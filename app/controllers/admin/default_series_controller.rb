class Admin::DefaultSeriesController < Admin::AdminController
  before_filter :set_admin_default_series

  active_scaffold :default_series do |config|
    config.list.columns = [:name, :default_age_groups]
  end

  private
  def set_admin_default_series
    @is_admin_default_series = true
  end
end
