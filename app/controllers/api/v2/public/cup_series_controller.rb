class Api::V2::Public::CupSeriesController < Api::V2::ApiBaseController
  def show
    @cup = Cup.where(id: params[:cup_id]).includes([:cup_series, races: [series: [competitors: [:age_group, :club, :series]]]]).first
    @cup_series = @cup.cup_series.where(id: params[:id]).first if @cup
    render status: 404, body: nil unless @cup_series
  end
end
