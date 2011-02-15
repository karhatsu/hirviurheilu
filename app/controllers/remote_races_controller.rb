class RemoteRacesController < ApplicationController
  before_filter :check_user

  def create
    @race = Race.new(params[:race])
    if @race.save
      @user.races << @race
      redirect_to_success
    else
      redirect_to_error @race.errors.full_messages.join('. ') + '.'
    end
  end

  private
  def check_user
    @user = User.find_by_email(params[:email])
    unless @user and @user.valid_password?(params[:password])
      redirect_to_error "Virheelliset tunnukset"
    end
  end

  def redirect_to_success
    redirect_to "#{params[:source]}/official/races/#{params[:race_id]}/upload/success"
  end

  def redirect_to_error(message)
    redirect_to "#{params[:source]}/official/races/#{params[:race_id]}/upload/error?" +
        "message=#{CGI::escape(message)}&server=#{CGI::escape(params[:server])}" +
        "&email=#{CGI::escape(params[:email])}"
  end
end
