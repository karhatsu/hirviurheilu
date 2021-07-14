class Api::V2::Public::SeriesController < Api::V2::ApiBaseController
  def show
    @series = Series.where(id: params[:id]).first
    render status: 404, body: nil unless @series
  end
end
