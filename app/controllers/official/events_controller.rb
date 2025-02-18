class Official::EventsController < Official::OfficialController
  def show
    @event = current_user.find_event params[:id]
    return redirect_to official_root_path unless @event
    respond_to do |format|
      format.html do
        use_react true
        render layout: true, html: ''
      end
      format.json
    end
  end

  def new
    use_react true
    render layout: true, html: ''
  end

  def create
    races = []
    params[:race_ids].each do |race_id|
      race = current_user.races.find(race_id)
      return render status: 400, json: { errors: ["Kilpailu #{race.name} kuuluu jo toiseen tapahtumaan"] } if race.event_id
      races << race
    end
    @event = Event.new event_params
    if @event.save
      races.each do |race|
        race.update_attribute :event_id, @event.id
      end
    else
      render status: 400, json: { errors: @event.errors.full_messages }
    end
  end

  def edit
    use_react true
    render layout: true, html: ''
  end

  def update
    @event = current_user.find_event params[:id]
    unless @event.update event_params
      render status: 400, json: { errors: @event.errors.full_messages }
    end
  end

  private

  def event_params
    params.require(:event).permit(:name)
  end
end
