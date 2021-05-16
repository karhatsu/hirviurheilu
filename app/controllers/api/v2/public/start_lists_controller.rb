class Api::V2::Public::StartListsController < Api::V2::ApiBaseController
  before_action :assign_series_by_series_id, :only => :show

  def show
  end
end
