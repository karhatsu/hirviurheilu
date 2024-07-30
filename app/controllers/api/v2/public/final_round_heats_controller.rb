class Api::V2::Public::FinalRoundHeatsController < Api::V2::ApiBaseController
  def index
    @race = Race.where(id: params[:race_id]).first
    render status: 404, body: nil unless @race
  end
end
