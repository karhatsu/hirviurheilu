class Api::V2::Public::NordicRacesController < Api::V2::ApiBaseController
  def trap
    @sub_sport = :trap
    render_api_response
  end

  def shotgun
    @sub_sport = :shotgun
    render_api_response
  end

  def rifle_moving
    @sub_sport = :rifle_moving
    render_api_response
  end

  def rifle_standing
    @sub_sport = :rifle_standing
    render_api_response
  end

  private

  def render_api_response
    @race = Race.where(id: params[:race_id]).first
    render status: 404, body: nil unless @race
  end
end
