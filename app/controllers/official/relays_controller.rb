class Official::RelaysController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race, :set_relays
  before_filter :handle_time_parameters, :only => [:create, :update]

  def index
  end

  def new
    @relay = @race.relays.build(:legs_count => 4)
  end

  def create
    @relay = @race.relays.build(params[:relay])
    if @relay.save
      flash[:success] = 'Viesti luotu. ' +
        'Klikkaa Joukkueet-linkkiä, niin pääset lisäämään viestiin osallistuvat joukkueet.'
      redirect_to official_race_relays_path(@race)
    else
      render :new
    end
  end

  private
  def set_relays
    @is_relays = true
  end

  def handle_time_parameters
    handle_time_parameter params[:relay], "start_time"
  end
end
