class Official::EventsController < Official::OfficialController
  def new
    use_react true
    render layout: true, html: ''
  end

  def create
    race_ids = params[:race_ids]
    @event = Event.new event_params
    if @event.save
      race_ids.each do |race_id|
        current_user.races.find(race_id).update_attribute :event_id, @event.id
      end
    else
      render status: 400, json: { errors: @event.errors.full_messages }
    end
  end

  private

  def event_params
    params.require(:event).permit(:name)
  end
end
