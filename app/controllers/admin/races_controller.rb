# encoding: UTF-8
class Admin::RacesController < Admin::AdminController
  before_action :set_admin_races
  
  def index
    @races = Race.includes(:users).order('start_date desc')
  end
  
  def show
    @race = Race.find(params[:id])
  end
  
  def update
    race = Race.find(params[:id])
    race.update!(video_params)
    flash[:success] = 'Kilpailu tallennettu'
    redirect_to admin_races_path
  end
  
  def destroy
    @race = Race.find(params[:id])
    if params[:confirm_name] == @race.name
      if @race.destroy
        flash[:success] = 'Kilpailu poistettu'
        redirect_to admin_races_path
      else
        render :show
      end
    else
      flash[:error] = 'Kilpailun nimi on väärä'
      render :show
    end
  end
  
  private
  def set_admin_races
    @is_admin_races = true
  end

  def video_params
    params.require(:race).permit(:video_source, :video_description)
  end
end