# encoding: UTF-8
class Official::RelaysController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race, :set_relays
  before_filter :assign_relay_by_id, :only => [:edit, :update, :destroy]
  before_filter :handle_time_parameters, :only => [:create, :update]
  before_filter :set_no_result_reason_options, :only => [:edit, :update]

  def index
  end

  def new
    @relay = @race.relays.build(:legs_count => 4)
  end

  def create
    @relay = @race.relays.build(params[:relay])
    if @relay.save
      flash[:success] = 'Viesti luotu. Voit nyt lisätä viestiin joukkueita.'
      redirect_to edit_official_race_relay_path(@race, @relay)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @relay.update_attributes(params[:relay])
      flash[:success] = 'Viestin tiedot päivitetty'
      redirect_to official_race_relays_path(@race)
    else
      render :edit
    end
  end

  def destroy
    @relay.destroy
    flash[:success] = 'Viesti poistettu'
    redirect_to official_race_relays_path(@race)
  end

  private
  def set_no_result_reason_options
    @no_result_reason_options = [['Normaali', '']]
    @no_result_reason_options << [RelayTeam::DNS, RelayTeam::DNS]
    @no_result_reason_options << [RelayTeam::DNF, RelayTeam::DNF]
  end

  def handle_time_parameters
    handle_time_parameter params[:relay], "start_time"
  end
end
