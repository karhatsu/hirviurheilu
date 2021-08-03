class AnnouncementsController < ApplicationController
  before_action :set_announcements_menu

  def index
    @announcements = Announcement.active
  end

  def show
    use_react
    render layout: true, html: ''
  end

  private

  def set_announcements_menu
    @is_announcements = true
  end
end
