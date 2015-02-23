class ActivationKeysController < ApplicationController
  before_action :require_user, :set_offline_info, :check_env

  def new
  end
  
  def create
    existing_activation_key = current_user.activation_key
    if params[:accept] or existing_activation_key
      if current_user.valid_password?(params[:password])
        invoicing_info = params[:invoicing_info]
        if existing_activation_key.nil? and invoicing_info.blank?
          flash[:error] = t('activation_keys.create.invoicing_information_missing')
          render :new
        else
          @activation_key = ActivationKey.get_key(current_user.email, params[:password])
          current_user.activation_key = @activation_key
          current_user.invoicing_info = invoicing_info unless invoicing_info.blank?
          current_user.save!
          LicenseMailer.license_mail(current_user).deliver_now unless existing_activation_key
          render :show
        end
      else
        flash[:error] = t('activation_keys.create.wrong_password')
        render :new
      end
    else
      flash[:error] = t('activation_keys.create.not_accepted')
      render :new
    end
  end

  private
  def check_env
    render :staging if Rails.env.staging?
  end

  def set_offline_info
    @is_offline_info = true
    @is_activation_key = true
  end
end
