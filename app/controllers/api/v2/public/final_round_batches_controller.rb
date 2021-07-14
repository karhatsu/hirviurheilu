class Api::V2::Public::FinalRoundBatchesController < Api::V2::ApiBaseController
  def index
    @race = Race.where(id: params[:race_id]).first
    render status: 404, body: nil unless @race
  end
end
