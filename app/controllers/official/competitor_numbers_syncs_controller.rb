class Official::CompetitorNumbersSyncsController < Official::OfficialController
  def show
    use_react true
    render layout: true, html: ''
  end

  def update
    @event = current_user.find_event params[:event_id]
    sync = CompetitorNumbersSync.new(@event, params[:first_number].to_i)
    sync.synchronize
    render status: 201, body: nil
  end
end
