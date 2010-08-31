class Admin::DefaultAgeGroupsController < Admin::AdminController
  active_scaffold :default_age_group do |config|
    config.list.columns = [:default_series, :name, :min_competitors]
  end
end
