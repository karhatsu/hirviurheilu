class AnnouncementsController < ApplicationController
  before_action :set_variant

  def show
    @announcement = Announcement.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @announcement }
    end
  end
end