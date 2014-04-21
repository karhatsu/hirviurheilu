# encoding: UTF-8
class LicensesController < ApplicationController
  before_action :check_offline

  def new
  end

  def create
    if ActivationKey.valid?(params[:email], params[:password], params[:activation_key])
      ActivationKey.create!(:comment => 'Success')
      flash[:success] = t('licenses.create.success')
      redirect_to root_path
    else
      flash[:error] = t('licenses.create.error')
      render :new
    end
  end

  private
  def check_offline
    redirect_to root_path if online?
  end
end
