class ActivationKeysController < ApplicationController
  def new
  end

  def create
    if params[:accept]
      @activation_key = ActivationKey.get_key(current_user.email, 'license') #TODO!!!
      current_user.activation_key = @activation_key
      current_user.save!
      render :show
    else
      flash[:error] = 'Sinun täytyy hyväksyä käyttöehdot'
      render :new
    end
  end
end
