class Api::V2::Public::RacesController < Api::V2::ApiBaseController
  def show
    @race = Race.where(id: params[:id]).includes(series: [:race, competitors: [:club, series: [:race]]]).first
    render status: 404, body: nil unless @race
  end
end
