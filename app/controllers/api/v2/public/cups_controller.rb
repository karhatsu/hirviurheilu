class Api::V2::Public::CupsController < Api::V2::ApiBaseController
  def show
    @cup = Cup.where(id: params[:id]).includes(:cup_series, :cup_team_competitions, :races).first
    render status: 404, body: nil unless @cup
  end
end
