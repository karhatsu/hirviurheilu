class Api::V2::Public::EuropeanRiflesController < Api::V2::ApiBaseController
  def show
    @series = Series.where(id: params[:series_id]).first
    render status: 404, body: nil unless @series
  end
end
