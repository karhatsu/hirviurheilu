class Official::ExportsController < Official::OfficialController
  before_filter :define_servers, :set_export
  before_filter :assign_race_by_race_id, :check_assigned_race

  def new
  end

  def success
    if offline?
      flash[:success] = 'Kilpailun tiedot ladattu kohdejärjestelmään'
    else
      flash[:success] = 'Kilpailun tiedot ladattu omalle koneellesi'
    end
    redirect_to new_official_race_exports_path(@race)
  end

  def error
    flash[:error] = params[:message]
    render :new
  end

  private
  def set_export
    @is_export = true
  end

  def define_servers
    @servers = []
    @servers << ["Hirviurheilu (#{PRODUCTION_URL})", PRODUCTION_URL]
    @servers << ["Hirviurheilun harjoitusversio (#{TEST_URL})", TEST_URL]
    @servers << ["Localhost", ''] if Rails.env == 'development'
    @servers << ["Integration test", ''] if Rails.env == 'test'
  end
end
