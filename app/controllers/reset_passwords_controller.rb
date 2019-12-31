class ResetPasswordsController < ApplicationController
  before_action :require_no_user

  def new
  end

  def create
    reset_hash = generate_hash
    user = User.find_by_email(params[:email])
    if user
      user.reset_hash = reset_hash
      user.save!
      ResetPasswordMailer.reset_mail(params[:email], reset_hash).deliver_now
      flash[:success] = t('reset_passwords.create.email_sent')
      redirect_to reset_password_path
    else
      flash[:error] = t('reset_passwords.create.unknown_email')
      render :new
    end
  end

  def show
  end

  def edit
    @reset_hash = params[:reset_hash]
    @hash_ok = true
    unless User.find_by_reset_hash(@reset_hash)
      flash[:error] = t('reset_passwords.edit.unknown_hash')
      @hash_ok = false
    end
  end

  def update
    @reset_hash = params[:reset_hash]
    @hash_ok = true
    if params[:password].blank?
      flash[:error] = t('reset_passwords.update.write_new_password')
      render :edit
      return
    end
    user = User.find_by_reset_hash(@reset_hash)
    if user
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
      if user.save
        flash[:success] = t('reset_passwords.update.password_changed')
        redirect_to account_path
      else
        flash[:error] = user.errors.full_messages.join(". ") + "."
        render :edit
      end
    else
      @hash_ok = false
      flash[:error] = t('reset_passwords.update.user_not_found')
      render :edit
    end
  end

  private
  def generate_hash
    SecureRandom.hex.downcase
  end
end
