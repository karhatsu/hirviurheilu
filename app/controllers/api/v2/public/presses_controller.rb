class Api::V2::Public::PressesController < Api::V2::ApiBaseController
  def show
    @race = Race.where(id: params[:race_id]).includes(series: [competitors: [:age_group, :club]]).first
    render status: 404, body: nil unless @race
  end
end
