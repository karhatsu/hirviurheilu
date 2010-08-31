class Admin::DefaultSeriesController < Admin::AdminController
  active_scaffold :default_series do |config|
    config.list.columns = [:name, :default_age_groups]
  end
end
