class Official::CompetitorNumbersSyncsController < Official::OfficialController
  def show
    use_react true
    render layout: true, html: ''
  end

  def update
    @event = current_user.events.find(params[:event_id]).first
    sync = CompetitorNumbersSync.new(@event.races.map(&:id), params[:first_number].to_i)
    sync.synchronize
    render status: 201, body: nil
  end
end
