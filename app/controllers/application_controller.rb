class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user, :official_rights,
    :online?, :offline?
  before_filter :set_competitions, :ensure_user_in_offline

  private
  def official_rights
    current_user and (current_user.official? or current_user.admin?)
  end

  def offline?
    Mode.offline?
  end

  def online?
    Mode.online?
  end

  def ensure_user_in_offline
    return if online? or @current_user_session
    unless @current_user
      @current_user = User.first
      @current_user = User.create_offline_user unless @current_user
    end
    @user_session = UserSession.login_offline_user
    raise "Could not create user session" unless @user_session
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      store_location
      flash[:error] = "Sinun täytyy kirjautua sisään nähdäksesi pyydetyn sivun"
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:error] = "Sinulla on jo käyttäjätunnukset ja olet kirjautunut sisään"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def assign_race_by_id
    assign_race params[:id]
  end

  def assign_race_by_race_id
    assign_race params[:race_id]
  end

  def assign_race(id)
    begin
      @race = Race.find(id)
    rescue ActiveRecord::RecordNotFound
      @id = id
      render 'errors/race_not_found'
    end
  end

  def assign_series_by_id
    assign_series params[:id]
  end

  def assign_series_by_series_id
    assign_series params[:series_id]
  end

  def assign_series(id)
    begin
      @series = Series.find(id)
    rescue ActiveRecord::RecordNotFound
      @id = id
      render 'errors/series_not_found'
    end
  end

  def assign_relay_by_id
    assign_relay params[:id]
  end

  def assign_relay_by_relay_id
    assign_relay params[:relay_id]
  end

  def assign_relay(id)
    begin
      @relay = Relay.find(id)
    rescue ActiveRecord::RecordNotFound
      @id = id
      render 'errors/relay_not_found'
    end
  end

  def set_competitions
    @is_competitions = true
  end

  def site_url
    request.protocol + request.host_with_port
  end

  def rescue_with_handler(exception)
    ErrorMailer.error_mail("Virhe Hirviurheilussa", exception,
      request.fullpath, current_user).deliver
    super
  end

  # f.time_text_field / f.time_select creates hidden date fields and visible text fields.
  # When time is entered the first time, the params sent contain an empty date
  # and non-empty time. This throws an error in assigning multiparameter values.
  # For that reason we must define also date parameters before assigning form
  # parameters to the company object.
  # When the time fields are cleared, we must do the opposite: we must reset
  # the date fields since otherwise the time after update would be 0:00:00.
  def handle_time_parameter(object, time_name)
    return if params[:no_times]
    if time_cleared?(object, time_name)
      reset_date_parameters(object, time_name)
    else
      set_default_date_parameters(object, time_name)
    end
  end

  def time_cleared?(object_params, time_name)
    object_params["#{time_name}(4i)"] == '' and
      object_params["#{time_name}(5i)"] == '' and
      object_params["#{time_name}(6i)"] == ''
  end

  def reset_date_parameters(object_params, time_name)
    object_params["#{time_name}(1i)"] = ""
    object_params["#{time_name}(2i)"] = ""
    object_params["#{time_name}(3i)"] = ""
  end

  def set_default_date_parameters(object_params, time_name)
    object_params["#{time_name}(1i)"] = "2000"
    object_params["#{time_name}(2i)"] = "1"
    object_params["#{time_name}(3i)"] = "1"
  end
end
