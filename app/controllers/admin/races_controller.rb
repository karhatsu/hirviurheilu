class Admin::RacesController < Admin::AdminController
  before_action :set_admin_races

  def index
    @past_races = Race.where('start_date<?', Date.today)
    @future_races = Race.where('start_date>=?', Date.today)
    if params[:no_billing]
      @past_races = @past_races.where("billing_info is null or billing_info=''")
      @future_races = @future_races.where("billing_info is null or billing_info=''")
    end
    @past_races = @past_races.includes(:users).order('start_date desc')
    @future_races = @future_races.includes(:users).order('start_date desc')
  end

  def show
    @race = Race.find(params[:id])
  end

  def edit
    @race = Race.find(params[:id])
  end

  def update
    race = Race.find(params[:id])
    race.update!(billing_info_params)
    flash[:success] = 'Kilpailu tallennettu'
    redirect_to admin_races_path(no_billing: params[:no_billing])
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

  def billing_info_params
    params.require(:race).permit(:billing_info)
  end
end
