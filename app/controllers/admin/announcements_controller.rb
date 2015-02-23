class Admin::AnnouncementsController < Admin::AdminController
  before_action :set_admin_announcements
  
  def index
    @announcements = Announcement.all
  end
  
  def new
    @announcement = Announcement.new
  end
  
  def create
    @announcement = Announcement.new(announcement_params)
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
    if @announcement.update(announcement_params)
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

  def announcement_params
    params.require(:announcement).permit(:published, :title, :content, :active)
  end
end