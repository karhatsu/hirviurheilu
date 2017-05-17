class UserSessionsController < ApplicationController
  before_action :set_variant
  before_action :require_no_user, :only => [:new, :create]
  before_action :require_user, :only => :destroy

  def new
    session[:return_to] = params[:return_to] if params[:return_to]
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(session_params)
    if @user_session.save
      flash[:success] = t('user_sessions.create.login_succeeded')
      redirect_back_or_default root_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:success] = t('user_sessions.destroy.logout_succeeded')
    redirect_back_or_default root_path
  end

  private

  def session_params
    params.require(:user_session).permit(:email, :password, :remember_me)
  end
end
