class Api::V2::Public::EuropeanRiflesController < Api::V2::ApiBaseController
  before_action :assign_race_with_optional_series

  def show
  end
end
