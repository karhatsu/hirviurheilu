class Official::CompetitorNumberSyncsController < Official::OfficialController
  def index
    use_react true
    render layout: true, html: ''
  end

  def create
    sync = CompetitorNumbersSync.new(params[:race_ids].map(&:to_i), params[:first_number].to_i)
    sync.synchronize
    render status: 201, body: nil
  end
end
