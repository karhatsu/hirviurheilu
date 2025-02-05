class Official::CompetitorNumberSyncsController < Official::OfficialController
  def index
    use_react true
    render layout: true, html: ''
  end
end
