class ActivationKeysController < ApplicationController
  before_filter :check_env, :require_user

  def new
  end

  def create
    if params[:accept]
      if current_user.valid_password?(params[:password])
        @activation_key = ActivationKey.get_key(current_user.email, params[:password])
        current_user.activation_key = @activation_key
        current_user.save!
        render :show
      else
        flash[:error] = 'Väärä salasana'
        render :new
      end
    else
      flash[:error] = 'Sinun täytyy hyväksyä käyttöehdot'
      render :new
    end
  end

  private
  def check_env
    redirect_to root_path if Rails.env('staging')
  end
end
