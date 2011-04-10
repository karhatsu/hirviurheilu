class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    session[:return_to] = params[:return_to] if params[:return_to]
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "Kirjautuminen onnistui"
      redirect_back_or_default root_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:success] = "Olet kirjautunut ulos järjestelmästä"
    redirect_back_or_default root_path
  end
end
