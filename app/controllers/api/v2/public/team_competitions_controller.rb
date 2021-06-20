class Api::V2::Public::TeamCompetitionsController < Api::V2::ApiBaseController
  def show
    @tc = TeamCompetition.where(id: params[:id]).first
    render status: 404, body: nil unless @tc
  end
end
