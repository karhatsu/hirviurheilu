class Admin::RacesController < Admin::AdminController
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }

  before_action :set_admin_races

  def index
    @past_races = Race.where('start_date<?', Date.today).order('start_date desc')
    @future_races = Race.where('start_date>=?', Date.today).order('start_date desc')
  end

  def show
    @race = Race.find(params[:id])
  end

  def update
    race = Race.find(params[:id])
    if race.update(params.require(:race).permit(:level))
      render status: 204, body: nil
    else
      render status: 500, body: 'ERROR'
    end
  end

  def destroy
    @race = Race.find(params[:id])
    if params[:confirm_name] == @race.name
      begin
        @race.destroy!
        flash[:success] = 'Kilpailu poistettu'
        redirect_to admin_races_path
      rescue => e
        flash[:error] = e.record.errors.full_messages.join('. ')
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
end
