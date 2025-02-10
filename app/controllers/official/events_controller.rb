class Official::EventsController < Official::OfficialController
  def new
    use_react true
    render layout: true, html: ''
  end
end
