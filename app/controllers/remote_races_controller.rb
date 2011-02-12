class RemoteRacesController < ApplicationController
  before_filter :init_race, :check_user

  def create
    respond_to do |format|
      if @race.save
        @user.races << @race
        format.xml { render :xml => @race, :status => :created, :location => @race }
      else
        format.xml { render :xml => @race.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def init_race
    @race = Race.new(params[:remote_race])
  end

  def check_user
    @user = User.find_by_email(params[:remote_race][:email])
    unless @user and @user.valid_password?(params[:remote_race][:password])
      @race.errors.add(:base, 'Virheelliset tunnukset')
      render :xml => @race.errors, :status => :unprocessable_entity
    end
  end
end
