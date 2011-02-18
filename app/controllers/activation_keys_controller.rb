class ActivationKeysController < ApplicationController
  def create
    if params[:accept]
      @activation_key = ActivationKey.get_key(current_user.email, 'license') #TODO!!!
      render 'activation_keys/show'
    else
      flash[:error] = 'Sinun täytyy hyväksyä käyttöehdot'
      render 'licenses/show'
    end
  end
end
