# encoding: UTF-8
class Admin::AnnouncementsController < Admin::AdminController
  before_filter :set_admin_announcements
  
  def index
    @announcements = Announcement.all
  end
  
  def new
    @announcement = Announcement.new
  end
  
  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      flash[:success] = 'Tiedote lisätty'
      redirect_to admin_announcements_path
    else
      render :new
    end
  end
  
  def edit
    @announcement = Announcement.find(params[:id])
  end
  
  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update(params[:announcement])
      flash[:success] = 'Tiedote päivitetty'
      redirect_to admin_announcements_path
    else
      render :edit
    end
  end
  
  private
  def set_admin_announcements
    @is_admin_announcements = true
  end
end