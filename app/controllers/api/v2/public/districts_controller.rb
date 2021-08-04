class Api::V2::Public::DistrictsController < Api::V2::ApiBaseController
  def index
    @districts = District.all
  end
end
