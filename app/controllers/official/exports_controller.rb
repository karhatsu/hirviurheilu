class Official::ExportsController < Official::OfficialController
  before_filter :define_servers, :set_upload
  before_filter :assign_race_by_race_id, :check_assigned_race, :check_offline

  def new
  end

  def success
    flash[:success] = 'Kilpailun tiedot ladattu kohdejärjestelmään'
    redirect_to new_official_race_exports_path(@race)
  end

  def error
    flash[:error] = params[:message]
    render :new
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
    @servers << ["Localhost", ''] if Rails.env == 'development'
    @servers << ["Integration test", ''] if Rails.env == 'test'
  end
end
