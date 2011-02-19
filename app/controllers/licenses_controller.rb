class LicensesController < ApplicationController
  before_filter :check_offline

  def new
  end

  def create
    if ActivationKey.valid?(params[:email], params[:password], params[:activation_key])
      ActivationKey.create!(:comment => 'Success')
      flash[:success] = 'Hirviurheilun offline-versiosi on aktivoitu. ' +
        'Voit käyttää nyt tuotetta ilman rajoituksia.'
      redirect_to root_path
    else
      flash[:error] = 'Virheellinen aktivointitunnus'
      render :new
    end
  end

  private
  def check_offline
    redirect_to root_path if online?
  end
end
