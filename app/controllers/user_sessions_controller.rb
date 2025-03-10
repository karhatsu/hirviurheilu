class UserSessionsController < ApplicationController
  before_action :require_no_user, :only => [:new, :create]
  before_action :require_user, :only => :destroy

  def new
    @is_login = true
    session[:return_to] = params[:return_to] if params[:return_to]
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(session_params.to_h)
    if @user_session.save
      redirect_back_or_default root_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_back_or_default root_path
  end

  private

  def session_params
    params.require(:user_session).permit(:email, :password, :remember_me)
  end
end
