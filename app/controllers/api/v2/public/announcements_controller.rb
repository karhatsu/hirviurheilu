class Api::V2::Public::AnnouncementsController < Api::V2::ApiBaseController
  def show
    @announcement = Announcement.where(id: params[:id]).first
    render status: 404, body: nil unless @announcement
  end
end
