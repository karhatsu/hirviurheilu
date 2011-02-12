class Official::UploadsController < Official::OfficialController
  before_filter :define_servers, :set_upload
  before_filter :assign_race_by_race_id, :check_assigned_race, :check_offline

  def new
  end

  def create
    RemoteRace.site = params[:server]
    attrs = @race.attributes
    attrs.delete("id")
    attrs[:email] = params[:email]
    attrs[:password] = params[:password]
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
  def set_upload
    @is_upload = true
  end

  def check_offline
    redirect_to official_race_path(@race) if online?
  end

  def define_servers
    @servers = []
    @servers << ["Hirviurheilu (#{PRODUCTION_URL})", PRODUCTION_URL]
    @servers << ["Hirviurheilun harjoitusversio (#{TEST_URL})", TEST_URL]
    localhost = 'http://localhost:3000'
    @servers << ["Localhost (#{localhost})", localhost] if Rails.env == 'development' or
      Rails.env == 'test'
  end
end
