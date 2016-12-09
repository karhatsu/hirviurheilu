require 'database_helper'
class ApplicationController < ActionController::Base
  include AssignModel

  protect_from_forgery
  helper_method :current_user_session, :current_user, :official_rights,
    :online?, :offline?, :own_race?, :result_rotation_cookie_name, :result_rotation_scroll_cookie_name,
    :result_rotation_tc_cookie_name, :result_rotation_selected_competitions_cookie_name
  before_action :test_error_email
  before_action :ensure_user_in_offline
  before_action :set_locale
  before_action :clear_old_data_from_staging
  before_action :assign_races_for_main_menu
  before_action :allow_rack_profiler
  
  private
  def set_locale
    new_locale = params[:new_locale]
    if new_locale and valid_locale?(new_locale)
      I18n.locale = new_locale
      redirect_to path_after_locale_change(new_locale)
    elsif valid_locale?(params[:locale])
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end

  def valid_locale?(locale)
    %w(fi sv).include? locale
  end
  
  def path_after_locale_change(new_locale)
    new_locale = new_locale.to_s
    default_locale = I18n.default_locale.to_s
    path = request.path
    if path =~ /^\/#{default_locale}/
      if new_locale == default_locale
        return path.gsub(/^\/#{default_locale}/, '')
      else
        return path.gsub(/^\/#{default_locale}/, '/' + new_locale)
      end
    elsif path =~ /^\/sv/
      if new_locale == default_locale
        return path.gsub(/^\/sv/, '')
      else
        return path
      end
    elsif new_locale == default_locale
      return path
    elsif path == '/'
      return '/' + new_locale
    else
      return '/' + new_locale + path
    end
  end

  def default_url_options(options={})
    if I18n.locale == I18n.default_locale
      { :locale => nil }
    else
      { :locale => I18n.locale }
    end
  end

  def official_rights
    current_user and (current_user.official? or current_user.admin?)
  end

  def own_race?(race)
    current_user and (current_user.admin? or current_user.official_for_race?(race))
  end
  
  def own_cup?(cup)
    current_user and (current_user.admin? or current_user.official_for_cup?(cup))
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
      unless @current_user
        Role.ensure_default_roles_exist
        Sport.ensure_default_sports_exist
        @current_user = User.create_offline_user
      end
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
      flash[:error] = t(:login_required)
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
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

  def set_races
    @is_races = true
  end
  
  def result_rotation_cookie_name
    'seriescount'
  end
  
  def result_rotation_scroll_cookie_name
    'result_rotation_scroll'
  end
  
  def result_rotation_tc_cookie_name
    'result_rotation_tc'
  end

  def result_rotation_selected_competitions_cookie_name
    'result_rotation_competitions'
  end
  
  def pdf_header(title)
    { :left => replace_scands(title), :right => Date.today.strftime('%d.%m.%Y'),
      :spacing => 10, :font_size => 10 }
  end
  
  def replace_scands(title)
    title.gsub('ä', 'a').gsub('ö', 'o').gsub('Ä', 'A').gsub('Ö', 'O') if title
  end
  
  def pdf_footer
    { :center => 'www.hirviurheilu.com', :spacing => 10, :line => true }
  end
  
  def pdf_margin
    { :top => 20, :bottom => 20 }
  end

  def test_error_email
    raise 'Testing error email' if params[:test_error_email] == 'true'
  end

  def rescue_with_handler(exception)
    return super if Mode.offline?
    return if exception.is_a? ActionController::InvalidCrossOriginRequest
    begin
      ErrorMailer.error_mail("Virhe Hirviurheilussa", exception,
        request, params, current_user).deliver_now
    rescue
      p "Cannot send error email for exception: #{exception}"
    end
    super
  end

  # f.time_text_field / f.time_select creates hidden date fields and visible text fields.
  # When time is entered the first time, the params sent contain an empty date
  # and non-empty time. This throws an error in assigning multiparameter values.
  # For that reason we must define also date parameters before assigning form
  # parameters to the competitor object.
  # When the time fields are cleared, we must do the opposite: we must reset
  # the date fields since otherwise the time after update would be 0:00:00.
  # The check can be skipped with 'no_times' parameter.
  # The check is also skipped in case the given parameter is not sent in the request.
  def handle_time_parameter(object, time_name)
    return true if params[:no_times]
    return true if object.nil? || no_time_parameter(object, time_name)
    return false unless valid_time?(object, time_name)
    if time_cleared?(object, time_name)
      reset_date_parameters(object, time_name)
    else
      set_default_date_parameters(object, time_name)
    end
    true
  end
  
  def no_time_parameter(object_params, time_name)
    object_params["#{time_name}(4i)"].nil? and object_params["#{time_name}(5i)"].nil? and
      object_params["#{time_name}(6i)"].nil?
  end
  
  def valid_time?(object_params, time_name)
    h = object_params["#{time_name}(4i)"]
    min = object_params["#{time_name}(5i)"]
    sec = object_params["#{time_name}(6i)"]
    return true if h.blank? and min.blank? and sec.blank?
    h.match /^\d\d?$/ and min.match /^\d\d?$/ and (sec.blank? or sec.match /^\d\d?$/) and
      h.to_i >= 0 and h.to_i <= 23 and min.to_i >= 0 and min.to_i <= 59 and
      sec.to_i >= 0 and sec.to_i <= 59
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
  
  def pick_non_cup_races(races, cup_races)
    races.select { |race| !cup_races.include?(race) }
  end

  def set_is_info
    @is_info = true
  end

  def clear_old_data_from_staging
    if ProductionEnvironment.staging? && DatabaseHelper.postgres?
      ActiveRecord::Base.connection.execute('delete from user_sessions where updated_at < now()::date - 30')
    end
  end

  def set_variant
    logger.info "user agent: #{request.user_agent}"
    return if set_forced_variant
    request.variant = :mobile if request.user_agent =~ /Mobi/ && request.user_agent !~ /iPad/
  end

  def set_forced_variant
    session[:request_variant] = :mobile if params[:variant] == 'mobile'
    session[:request_variant] = :normal if params[:variant] == 'normal'
    if session[:request_variant]
      request.variant = :mobile if session[:request_variant] == :mobile
      return true
    end
    false
  end

  def assign_races_for_main_menu
    @main_menu_races = Race.where('start_date>?', 7.days.ago).order('start_date desc')
  end

  def allow_rack_profiler
    Rack::MiniProfiler.authorize_request if current_user && current_user.admin?
  end
end
