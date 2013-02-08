class AnnouncementsController < ApplicationController
  def show
    announcement = Announcement.find(params[:id])
    respond_to do |format|
      format.json { render :json => announcement }
    end
  end
end