class Api::V2::Public::EventsController < Api::V2::ApiBaseController
  def show
    @event = Event.find params[:id]
    render status: 404, body: nil unless @event
  end
end
