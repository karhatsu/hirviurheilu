class Api::V2::Public::RelaysController < Api::V2::ApiBaseController
  def show
    @relay = Relay.where(id: params[:id]).first
    render status: 404, body: nil unless @relay
  end
end
