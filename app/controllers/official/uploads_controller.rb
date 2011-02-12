class Official::UploadsController < Official::OfficialController
  before_filter :define_servers
  before_filter :assign_race_by_race_id, :check_assigned_race, :check_offline, :except => :create

  def new
  end

  def create
    RemoteRace.site = params[:server]
    @race = Race.find(params[:race_id])
    attrs = @race.attributes
    attrs.delete("id")
    remote_race = RemoteRace.new(attrs)
    if remote_race.save
      flash[:success] = 'Kilpailun tiedot ladattu kohdejärjestelmään'
      redirect_to new_official_race_uploads_path(@race)
    else
      flash[:error] = remote_race.errors.full_messages.join('. ') + '.'
      render :new
    end
  end

  private
  def check_offline
    redirect_to official_race_path(@race) if online?
  end

  def define_servers
    @servers = []
    @servers << ['Hirviurheilu', PRODUCTION_URL]
    @servers << ['Hirviurheilu (testi)', TEST_URL]
    @servers << ['Same server', 'http://localhost:3000'] if Rails.env == 'development' or
      Rails.env == 'test'
  end
end
