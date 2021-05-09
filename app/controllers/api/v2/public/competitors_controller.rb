class Api::V2::Public::CompetitorsController < Api::V2::ApiBaseController
  def show
    race = Race.where(id: params[:race_id]).first
    return render status: 404, body: nil unless race
    @competitor = race.competitors.where(number: params[:competitor_number]).first
    render status: 404, body: nil unless @competitor
  end
end
