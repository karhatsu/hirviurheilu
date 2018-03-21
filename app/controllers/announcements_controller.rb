class AnnouncementsController < ApplicationController
  before_action :set_variant, :set_announcements_menu

  def index
    @announcements = Announcement.active
  end

  def show
    @announcement = Announcement.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @announcement }
    end
  end

  private

  def set_announcements_menu
    @is_announcements = true
  end
end