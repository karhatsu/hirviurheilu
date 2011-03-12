class Official::RelaysController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race, :set_relays
  before_filter :assign_relay_by_id, :only => [:edit, :update]
  before_filter :handle_time_parameters, :only => [:create, :update]

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

  private
  def handle_time_parameters
    handle_time_parameter params[:relay], "start_time"
  end
end
