class PasswordsController < ApplicationController
  before_action :require_user, :set_account

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user
    if @user.update(user_params)
      flash[:success] = t('users.update.password_changed')
      redirect_to account_url
    else
      render action: :edit
    end
  end

  private

  def set_account
    @is_account = true
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
